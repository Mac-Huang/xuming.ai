import { GitHub, RAW, REPO, BRANCH, validDate, entryPath } from './core.mjs?v=20260924-markdown';
import { toMarkdownEntry, renderMarkdown, mediaPath, markdownImage } from './markdown.mjs?v=20260924-markdown';

const $ = id => document.getElementById(id);
const github = new GitHub();
const TOKEN_KEY = 'xuming-journal-github-token';
function storedToken() { try { return localStorage.getItem(TOKEN_KEY) || ''; } catch { return ''; } }
function persistToken(token) {
  try { if(token) localStorage.setItem(TOKEN_KEY,token); else localStorage.removeItem(TOKEN_KEY); return true; }
  catch { return false; }
}
const today = () => { const d = new Date(); return `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}`; };
const drafts = new Map();
let database, date = today(), month = date.slice(0,7), sha = null, remote = null;
let known = false, dirty = false, busy = false, mediaBusy = false, loading = false, conflict = false, revision = 0, timer, monthRequest = 0;
let savedDays = new Set();
let pendingImages = {}, view = 'write';
let draftFailure = false;
function status(text, error = false) { $('status').textContent = text; $('status').classList.toggle('error', error); }
function snapshot() { return { date, title: $('title').value.trim(), markdown: $('editor').value, pendingImages: {...pendingImages}, updated: new Date().toISOString(), version: 2 }; }
function hasContent(entry) { return Boolean(entry.title || entry.markdown.trim()); }
function updatePreview() { $('preview').innerHTML=renderMarkdown($('editor').value,pendingImages); }
function setView(next) {
  view=next;$('editor').hidden=view!=='write';$('preview').hidden=view!=='preview';$('toolbar').hidden=view!=='write';
  $('write-view').setAttribute('aria-pressed',String(view==='write'));$('preview-view').setAttribute('aria-pressed',String(view==='preview'));
  if(view==='preview')updatePreview();else $('editor').focus();
}
function insertText(text) {
  const editor=$('editor');editor.focus();editor.setRangeText(text,editor.selectionStart,editor.selectionEnd,'end');changed();
}
$('write-view').onclick=()=>setView('write');$('preview-view').onclick=()=>setView('preview');
function controls() {
  $('save').disabled = !known || !dirty || busy || mediaBusy || conflict || !github.token;
  $('date').disabled = busy || mediaBusy || loading;
  for (const id of ['previous','next','today','reload']) $(id).disabled = busy || mediaBusy || loading;
  $('title').disabled = loading;
  $('export').disabled = loading;
  $('history').hidden = !sha;
  $('editor').disabled = loading;
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
function wordCount() { const text = $('editor').value.replace(/!\[[^\]]*\]\([^)]*\)/g,'').trim(); $('word-count').textContent = `${text ? text.split(/\s+/u).length : 0} words`; }
function changed() {
  dirty = true; revision++; wordCount(); updatePreview();
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
  const body = document.createElement('div'); body.innerHTML = renderMarkdown(toMarkdownEntry(remote.entry,date).markdown);
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
  $('date').value = date; $('conflict').hidden = true; $('title').value = ''; $('editor').value = ''; pendingImages = {}; updatePreview();
  $('history').href = `https://github.com/${REPO}/commits/${BRANCH}/${entryPath(date)}`;
  if(month!==date.slice(0,7)) { month=date.slice(0,7); loadMonth(); }
  renderCalendar(); controls(); status('Loading entry…');
  const local = drafts.get(date);
  try {
    remote = await github.get(date); sha = remote.sha; known = true;
    const entry = toMarkdownEntry(local?.entry || remote.entry,date); pendingImages=entry.pendingImages;
    $('title').value = entry?.title || ''; $('editor').value = entry.markdown;
    if(local) {
      dirty = true;
      if(local.baseSha!==sha) { sha=local.baseSha; showConflict(); }
      else status(github.token?'Restored local draft · waiting to sync…':'Restored local draft · connect GitHub to sync');
    } else status(remote.entry ? 'Saved on GitHub' : 'A fresh page for this day');
  } catch(error) {
    remote = null;
    const entry=toMarkdownEntry(local?.entry,date);pendingImages=entry.pendingImages;
    $('title').value = entry.title || ''; $('editor').value = entry.markdown;
    dirty = Boolean(local); sha = local?.baseSha || null; status(`${error.message} Refresh before syncing.`, true);
  }
  loading = false; controls(); wordCount(); updatePreview(); schedule();
}
async function save() {
  clearTimeout(timer);
  if (busy || mediaBusy || !dirty || !known || conflict || !github.token) return;
  const entry = snapshot();
  if (!hasContent(entry) && !sha) { status('Write something before saving.'); return; }
  const version = revision; busy = true; controls(); status('Saving to GitHub…');
  try {
    for(const [path,source] of Object.entries(entry.pendingImages)) {
      if(!entry.markdown.includes(RAW+path))continue;
      if(!/^data:image\/(png|jpeg|webp|gif);base64,[a-zA-Z0-9+/=]+$/.test(source))throw new Error('An image draft could not be read. Remove it and insert it again.');
      const result = await github.put(path, source.split(',')[1], null, `Journal image: ${date}`);
      if(!result.content?.sha) throw new Error('GitHub did not confirm the image save.');
      delete pendingImages[path];
      await remember();
    }
    const {pendingImages: localImages, ...savedEntry}=entry;
    const result = await github.save(savedEntry, sha);
    if(!result.content?.sha) throw new Error('GitHub did not confirm the entry save.');
    sha = result.content.sha; remote = {sha,entry:savedEntry}; savedDays.add(date);
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
  setView('write');
  try {
    for(const file of files) {
      if(!['image/png','image/jpeg','image/webp','image/gif'].includes(file.type)) throw new Error('Choose a PNG, JPG, WebP, or GIF image.');
      if(file.size>20*1024*1024) throw new Error('Choose an image smaller than 20 MB.');
      const bitmap = await createImageBitmap(file);
      const scale = Math.min(1,2048/Math.max(bitmap.width,bitmap.height));
      const canvas = document.createElement('canvas'); canvas.width=Math.max(1,Math.round(bitmap.width*scale));canvas.height=Math.max(1,Math.round(bitmap.height*scale));
      canvas.getContext('2d').drawImage(bitmap,0,0,canvas.width,canvas.height);bitmap.close();
      const data = canvas.toDataURL('image/webp',.85);
      const path=mediaPath(date);pendingImages[path]=data;
      insertText(`\n\n${markdownImage(file.name,RAW+path)}\n\n`);

    }
  } catch(error) { status(error.message,true); }
  finally { mediaBusy=false; controls(); schedule(); }
}
$('title').addEventListener('input',changed); $('editor').addEventListener('input',changed);
$('toolbar').addEventListener('mousedown', event => { if(event.target.closest('button'))event.preventDefault(); });
$('toolbar').addEventListener('click',event=>{
  const button=event.target.closest('[data-markdown]');if(!button)return;
  const editor=$('editor'),selected=editor.value.slice(editor.selectionStart,editor.selectionEnd);
  const kind=button.dataset.markdown;
  const snippets={bold:`**${selected||'bold text'}**`,italic:`*${selected||'italic text'}*`,heading:`## ${selected||'Heading'}`,list:(selected||'List item').split('\n').map(line=>'- '+line).join('\n'),task:(selected||'Task').split('\n').map(line=>'- [ ] '+line).join('\n'),quote:(selected||'Quote').split('\n').map(line=>'> '+line).join('\n'),code:'```\n'+(selected||'code')+'\n```',link:`[${selected||'link text'}](https://)`};
  let text=snippets[kind];if(!text)return;
  if(['heading','list','task','quote','code'].includes(kind)) {
    if(editor.selectionStart && editor.value[editor.selectionStart-1]!=='\n')text='\n'+text;
    text+='\n';
  }
  insertText(text);
});
$('editor').addEventListener('paste',event=>{const files=[...event.clipboardData.files];if(files.length){event.preventDefault();addImages(files);}});
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
  if(github.token){github.token='';clearTimeout(timer);$('connect').textContent='Connect GitHub';const removed=persistToken('');status(removed?'Disconnected · saved token removed; drafts stay on this device':'Disconnected in this tab. Clear this site’s browser data to remove the saved connection.',!removed);controls();return;}
  $('connection-dialog').showModal();$('token').focus();
};
$('cancel-connect').onclick=()=>$('connection-dialog').close();
$('connection-dialog').addEventListener('close',()=>{$('token').value='';$('remember-token').checked=true;$('connection-error').textContent='';});
$('connection-form').onsubmit=async event=>{
  event.preventDefault();const submit=event.submitter;submit.disabled=true;$('connection-error').textContent='Checking access…';
  try{
    await github.connect($('token').value.trim());
    const persisted=persistToken($('remember-token').checked?github.token:'');
    $('connect').textContent='Disconnect GitHub';$('connection-dialog').close();await openDate(date,true);loadMonth();
    if(!persisted)status('Connected for this tab. Browser storage is unavailable; the connection preference could not be saved.',true);
  }
  catch(error){$('connection-error').textContent=error.message;}
  finally{submit.disabled=false;controls();}
};
$('export').onclick=()=>{
  const entry=snapshot();
  let markdown=(entry.title?'# '+entry.title+'\n\n':'')+entry.markdown+'\n';
  for(const [path,data] of Object.entries(pendingImages))markdown=markdown.replaceAll(RAW+path,data);
  const url=URL.createObjectURL(new Blob([markdown],{type:'text/markdown;charset=utf-8'})),link=document.createElement('a');link.href=url;link.download=`journal-${date}.md`;link.click();setTimeout(()=>URL.revokeObjectURL(url),1000);
};
window.addEventListener('beforeunload',event=>{if(dirty||busy||mediaBusy){event.preventDefault();event.returnValue='';}});
document.addEventListener('keydown',event=>{if((event.metaKey||event.ctrlKey)&&event.key==='s'){event.preventDefault();save();}});
window.addEventListener('storage',event=>{
  if(event.key===TOKEN_KEY && !event.newValue){github.token='';clearTimeout(timer);$('connect').textContent='Connect GitHub';status('Disconnected in another tab · drafts stay on this device');controls();}
});
async function start(){
  try{
    database=await new Promise((resolve,reject)=>{const request=indexedDB.open('xuming-journal',1);request.onupgradeneeded=()=>request.result.createObjectStore('drafts');request.onsuccess=()=>resolve(request.result);request.onerror=()=>reject(request.error);});
    await new Promise((resolve,reject)=>{const tx=database.transaction('drafts');const request=tx.objectStore('drafts').openCursor();request.onsuccess=()=>{const cursor=request.result;if(cursor){drafts.set(cursor.key,cursor.value);cursor.continue();}else resolve();};request.onerror=()=>reject(request.error);});
  }catch{draftFailure=true;}
  let connectionError='';
  const token=storedToken();
  if(token){
    $('connect').disabled=true;status('Reconnecting to GitHub…');
    try{await github.connect(token);$('connect').textContent='Disconnect GitHub';}
    catch(error){if(error.status===401)persistToken('');connectionError=`Could not reconnect. ${error.message}`;}
    finally{$('connect').disabled=false;}
  }
  await openDate(date,true);loadMonth();
  if(connectionError)status(connectionError,true);
  if(draftFailure)status('Local draft storage unavailable. Keep this tab open and export or sync your entry.',true);
}
start();
