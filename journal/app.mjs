import { GitHub, RAW, REPO, BRANCH, cleanHTML, validDate, entryPath } from './core.mjs';

const $ = id => document.getElementById(id);
const github = new GitHub();
const today = () => { const d = new Date(); return `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}`; };
const drafts = new Map();
let database, date = today(), month = date.slice(0,7), sha = null, remote = null;
let known = false, dirty = false, busy = false, mediaBusy = false, loading = false, conflict = false, revision = 0, timer, monthRequest = 0;
let savedDays = new Set();
let draftFailure = false;
function status(text, error = false) { $('status').textContent = text; $('status').classList.toggle('error', error); }
function snapshot() { return { date, title: $('title').value.trim(), html: cleanHTML($('editor').innerHTML), updated: new Date().toISOString(), version: 1 }; }
function hasContent(entry) { return Boolean(entry.title || entry.html.replace(/<[^>]*>/g,'').trim() || entry.html.includes('<img')); }
function controls() {
  $('save').disabled = !known || !dirty || busy || mediaBusy || conflict || !github.token;
  $('date').disabled = busy || mediaBusy || loading;
  for (const id of ['previous','next','today','reload']) $(id).disabled = busy || mediaBusy || loading;
  $('title').disabled = loading;
  $('export').disabled = loading;
  $('history').hidden = !sha;
  $('editor').contentEditable = String(!loading);
  for (const button of $('toolbar').querySelectorAll('button')) button.disabled = loading || mediaBusy;
  $('image').disabled = loading || mediaBusy || busy;
}
async function storeDraft(value, key = date) {
  if (value) drafts.set(key, value); else drafts.delete(key);
  try {
    await new Promise((resolve, reject) => {
      if (!database) return reject(new Error('Draft storage unavailable.'));
      const tx = database.transaction('drafts', 'readwrite');
      const store = tx.objectStore('drafts');
      if (value) store.put(value, key); else store.delete(key);
      tx.oncomplete = resolve; tx.onerror = () => reject(tx.error); tx.onabort = () => reject(tx.error);
    });
    draftFailure = false;
  } catch { draftFailure = true; status('Local draft storage unavailable. Keep this tab open and export or sync your entry.', true); }
}
function remember() { return storeDraft({ entry: snapshot(), baseSha: sha, known }); }
function wordCount() { const text = $('editor').textContent.trim(); $('word-count').textContent = `${text ? text.split(/\s+/u).length : 0} words`; }
function changed() {
  dirty = true; revision++; wordCount();
  remember().then(() => { if (!draftFailure && !busy && !conflict) status(github.token ? 'Draft saved on this device · waiting to sync…' : 'Draft saved on this device · connect GitHub to sync'); });
  renderCalendar(); schedule(); controls();
}
function schedule() {
  clearTimeout(timer);
  if (dirty && github.token && known && !conflict && !busy && !mediaBusy) timer = setTimeout(() => save(), 5000);
}
function renderCalendar() {
  const [year, m] = month.split('-').map(Number);
  $('month-label').textContent = new Date(year, m-1, 1).toLocaleDateString(undefined,{month:'long',year:'numeric'});
  const calendar = $('calendar'); calendar.replaceChildren();
  const offset = (new Date(year, m-1, 1).getDay()+6)%7;
  for (let i=0;i<offset;i++) calendar.append(document.createElement('span'));
  for (let day=1; day<=new Date(year,m,0).getDate();day++) {
    const key = `${month}-${String(day).padStart(2,'0')}`, button = document.createElement('button');
    button.type = 'button'; button.textContent = day; button.dataset.date = key;
    button.classList.toggle('today',key===today()); button.classList.toggle('selected',key===date);
    button.classList.toggle('has-entry',savedDays.has(key)); button.classList.toggle('has-draft',drafts.has(key));
    button.setAttribute('aria-label',`${key}${savedDays.has(key)?', saved entry':''}${drafts.has(key)?', local draft':''}`);
    if (key===date) button.setAttribute('aria-pressed','true');
    button.onclick = () => openDate(key); calendar.append(button);
  }
}
async function loadMonth() {
  const request = ++monthRequest;
  savedDays = new Set(); renderCalendar(); $('calendar-status').textContent = 'Loading entries…';
  try { const days = await github.month(month); if(request!==monthRequest)return; savedDays = new Set(days); $('calendar-status').textContent = days.length ? `${days.length} saved ${days.length===1?'day':'days'} this month` : 'No saved entries this month.'; }
  catch(error) { if(request!==monthRequest)return; $('calendar-status').textContent = error.message; }
  renderCalendar();
}
function showConflict() {
  conflict = true; $('conflict').hidden = false;
  const heading = document.createElement('strong'); heading.textContent = remote.entry?.title || '(No title)';
  const body = document.createElement('div'); body.innerHTML = cleanHTML(remote.entry?.html || '<p>No saved entry.</p>');
  $('remote-version').replaceChildren(heading, body);
  status('Your local draft differs from GitHub. Choose which version to keep.', true); controls();
}
async function openDate(nextDate, force = false) {
  if (!validDate(nextDate) || busy || mediaBusy || loading || (nextDate===date && !force)) return;
  clearTimeout(timer);
  loading = true; controls();
  // Finish a pending save before leaving a date. Failed saves remain local.
  if (dirty && known && github.token && !conflict && hasContent(snapshot()) && !force) await save();
  if (dirty) await remember();
  date = nextDate; loading = true; known = false; dirty = false; conflict = false; sha = null; revision = 0;
  $('date').value = date; $('conflict').hidden = true; $('title').value = ''; $('editor').replaceChildren();
  $('history').href = `https://github.com/${REPO}/commits/${BRANCH}/${entryPath(date)}`;
  if(month!==date.slice(0,7)) { month=date.slice(0,7); loadMonth(); }
  renderCalendar(); controls(); status('Loading entry…');
  const local = drafts.get(date);
  try {
    remote = await github.get(date); sha = remote.sha; known = true;
    const entry = local?.entry || remote.entry;
    $('title').value = entry?.title || ''; $('editor').innerHTML = cleanHTML(entry?.html || '');
    if(local) {
      dirty = true;
      if(local.baseSha!==sha) { sha=local.baseSha; showConflict(); }
      else status(github.token?'Restored local draft · waiting to sync…':'Restored local draft · connect GitHub to sync');
    } else status(remote.entry ? 'Saved on GitHub' : 'A fresh page for this day');
  } catch(error) {
    remote = null;
    $('title').value = local?.entry.title || ''; $('editor').innerHTML = cleanHTML(local?.entry.html || '');
    dirty = Boolean(local); sha = local?.baseSha || null; status(`${error.message} Refresh before syncing.`, true);
  }
  loading = false; controls(); wordCount(); schedule();
}
async function save() {
  clearTimeout(timer);
  if (busy || mediaBusy || !dirty || !known || conflict || !github.token) return;
  const entry = snapshot();
  if (!hasContent(entry) && !sha) { status('Write something before saving.'); return; }
  const version = revision; busy = true; controls(); status('Saving to GitHub…');
  try {
    const fragment = document.createElement('template'); fragment.innerHTML = entry.html;
    for(const image of fragment.content.querySelectorAll('img')) {
      const source = image.getAttribute('src');
      if(!source.startsWith('data:')) continue;
      const extension = /data:image\/(\w+);/.exec(source)[1];
      const path = `journal/media/${date.slice(0,7).replace('-','/')}/${crypto.randomUUID()}.${extension}`;
      const result = await github.put(path, source.split(',')[1], null, `Journal image: ${date}`);
      if(!result.content?.sha) throw new Error('GitHub did not confirm the image save.');
      const url = RAW+path; image.setAttribute('src',url);
      for(const live of $('editor').querySelectorAll('img')) if(live.getAttribute('src')===source) live.setAttribute('src',url);
      // Remember completed uploads even if the later entry save fails.
      await remember();
    }
    entry.html = fragment.innerHTML;
    const result = await github.save(entry, sha);
    if(!result.content?.sha) throw new Error('GitHub did not confirm the entry save.');
    sha = result.content.sha; remote = {sha,entry}; savedDays.add(date);
    dirty = revision !== version;
    if(dirty) await remember(); else await storeDraft(null);
    if(!draftFailure) status(dirty?'Saved · newer changes waiting to sync…':'Saved on GitHub');
  } catch(error) {
    if(error.status===409 || error.status===422) {
      try { remote=await github.get(date); showConflict(); } catch { known=false; status(error.message,true); }
    } else status(error.message,true);
    await remember();
  } finally { busy = false; controls(); renderCalendar(); }
  // Only follow new edits, never loop automatically after a failed request.
  if (revision !== version && !conflict) schedule();
}
async function addImages(files) {
  if(loading || busy || mediaBusy) { status('Wait for the current operation to finish, then insert the image again.'); return; }
  mediaBusy = true; clearTimeout(timer); controls();
  const selection = window.getSelection();
  const range = selection.rangeCount && $('editor').contains(selection.anchorNode) ? selection.getRangeAt(0).cloneRange() : null;
  try {
    for(const file of files) {
      if(!['image/png','image/jpeg','image/webp','image/gif'].includes(file.type)) throw new Error('Choose a PNG, JPG, WebP, or GIF image.');
      if(file.size>20*1024*1024) throw new Error('Choose an image smaller than 20 MB.');
      const bitmap = await createImageBitmap(file);
      const scale = Math.min(1,2048/Math.max(bitmap.width,bitmap.height));
      const canvas = document.createElement('canvas'); canvas.width=Math.max(1,Math.round(bitmap.width*scale));canvas.height=Math.max(1,Math.round(bitmap.height*scale));
      canvas.getContext('2d').drawImage(bitmap,0,0,canvas.width,canvas.height);bitmap.close();
      const data = canvas.toDataURL('image/webp',.85);
      $('editor').focus();
      if(range && files.length===1) { selection.removeAllRanges(); selection.addRange(range); }
      else if(!selection.rangeCount || !$('editor').contains(selection.anchorNode)) { const end=document.createRange();end.selectNodeContents($('editor'));end.collapse(false);selection.removeAllRanges();selection.addRange(end); }
      const img=document.createElement('img');img.src=data;img.alt=file.name;
      document.execCommand('insertHTML',false,`${img.outerHTML}<p><br></p>`);
      changed();
    }
  } catch(error) { status(error.message,true); }
  finally { mediaBusy=false; controls(); schedule(); }
}
$('title').addEventListener('input',changed); $('editor').addEventListener('input',changed);
$('toolbar').addEventListener('mousedown', event => { if(event.target.closest('button'))event.preventDefault(); });
$('toolbar').addEventListener('click',event=> {const button=event.target.closest('[data-command]');if(!button)return;$('editor').focus();document.execCommand(button.dataset.command,false,button.dataset.value);changed();});
$('editor').addEventListener('paste',event=>{event.preventDefault();const files=[...event.clipboardData.files];if(files.length){addImages(files);return;}document.execCommand('insertText',false,event.clipboardData.getData('text/plain'));changed();});
$('editor').addEventListener('dragover',event=>event.preventDefault());
$('editor').addEventListener('drop',event=>{event.preventDefault();if(event.dataTransfer.files.length)addImages([...event.dataTransfer.files]);});
$('image').onclick=()=>$('image-file').click(); $('image-file').onchange=event=>{addImages([...event.target.files]);event.target.value='';};
$('date').onchange=event=>{if(validDate(event.target.value))openDate(event.target.value);else event.target.value=date;};
for(const [id,delta] of [['previous',-1],['next',1]]) $(id).onclick=()=>{const [y,m]=month.split('-').map(Number);const d=new Date(y,m-1+delta,1);month=`${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}`;loadMonth();};
$('today').onclick=()=>{if(date===today()){month=date.slice(0,7);loadMonth();}else openDate(today());};
$('save').onclick=save;
$('reload').onclick=()=>openDate(date,true);
$('keep-draft').onclick=()=>{sha=remote.sha;known=true;conflict=false;$('conflict').hidden=true;changed();};
$('use-remote').onclick=async()=>{if(!confirm('Replace this local draft with the GitHub version? Export first if you want a separate copy.'))return;dirty=false;await storeDraft(null);await openDate(date,true);};
$('connect').onclick=()=>{
  if(github.token){github.token='';clearTimeout(timer);$('connect').textContent='Connect GitHub';status('Disconnected · drafts stay on this device');controls();return;}
  $('connection-dialog').showModal();$('token').focus();
};
$('cancel-connect').onclick=()=>$('connection-dialog').close();
$('connection-dialog').addEventListener('close',()=>{$('token').value='';$('connection-error').textContent='';});
$('connection-form').onsubmit=async event=>{
  event.preventDefault();const submit=event.submitter;submit.disabled=true;$('connection-error').textContent='Checking access…';
  try{await github.connect($('token').value.trim());$('connect').textContent='Disconnect GitHub';$('connection-dialog').close();await openDate(date,true);loadMonth();}
  catch(error){$('connection-error').textContent=error.message;}
  finally{submit.disabled=false;controls();}
};
$('export').onclick=()=>{
  const entry=snapshot(), heading=document.createElement('h1');heading.textContent=entry.title||entry.date;
  const html=`<!doctype html><meta charset="utf-8"><meta name="robots" content="noindex"><title>Journal ${entry.date}</title>${heading.outerHTML}<p>${entry.date}</p>${entry.html}`;
  const url=URL.createObjectURL(new Blob([html],{type:'text/html'})),link=document.createElement('a');link.href=url;link.download=`journal-${date}.html`;link.click();setTimeout(()=>URL.revokeObjectURL(url),1000);
};
window.addEventListener('beforeunload',event=>{if(dirty||busy||mediaBusy){event.preventDefault();event.returnValue='';}});
document.addEventListener('keydown',event=>{if((event.metaKey||event.ctrlKey)&&event.key==='s'){event.preventDefault();save();}});
async function start(){
  try{
    database=await new Promise((resolve,reject)=>{const request=indexedDB.open('xuming-journal',1);request.onupgradeneeded=()=>request.result.createObjectStore('drafts');request.onsuccess=()=>resolve(request.result);request.onerror=()=>reject(request.error);});
    await new Promise((resolve,reject)=>{const tx=database.transaction('drafts');const request=tx.objectStore('drafts').openCursor();request.onsuccess=()=>{const cursor=request.result;if(cursor){drafts.set(cursor.key,cursor.value);cursor.continue();}else resolve();};request.onerror=()=>reject(request.error);});
  }catch{draftFailure=true;}
  await openDate(date,true);loadMonth();
  if(draftFailure)status('Local draft storage unavailable. Keep this tab open and export or sync your entry.',true);
}
start();
