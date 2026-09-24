// Run with JOURNAL_URL pointing at a local server. Uses a disposable browser profile
// and a mock GitHub API; no real token or journal data is used.
import assert from 'node:assert/strict';
const {chromium}=await import(process.env.PLAYWRIGHT_MODULE || 'playwright');
const browser=await chromium.launch({headless:true,executablePath:process.env.BROWSER_EXECUTABLE || undefined});
const page=await browser.newPage({viewport:{width:1280,height:960}});
const files=new Map(), writes=[], errors=[];let counter=0,deny=false;
let png=Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jD1sAAAAASUVORK5CYII=','base64');
page.on('pageerror',error=>errors.push(error.message));
page.on('requestfailed',request=>console.log('Request failed:',request.url(),request.failure()?.errorText));
await page.route('https://raw.githubusercontent.com/**',route=>route.fulfill({status:200,contentType:'image/png',body:png}));
await page.route('https://api.github.com/**',async route=>{
  const request=route.request(),url=new URL(request.url());
  const path=url.pathname.split('/contents/')[1];
  const respond=(status,json)=>route.fulfill({status,headers:{'Access-Control-Allow-Origin':'*','Access-Control-Allow-Headers':'*','Access-Control-Allow-Methods':'GET, PUT, OPTIONS'},contentType:'application/json',body:JSON.stringify(json)});
  if(request.method()==='OPTIONS')return respond(200,{});
  if(!path)return respond(200,{permissions:{push:true}});
  if(request.method()==='PUT'){
    if(deny)return respond(403,{});
    assert.equal(request.headers().authorization,'Bearer test-only');
    const body=request.postDataJSON(),current=files.get(path);
    if((current?.sha||null)!==(body.sha||null))return respond(409,{});
    const file={sha:`sha-${++counter}`,content:body.content};files.set(path,file);writes.push({path,body});
    return respond(200,{content:{sha:file.sha}});
  }
  if(path.endsWith('.json'))return files.has(path)?respond(200,files.get(path)):respond(404,{});
  return respond(200,[...files.keys()].filter(p=>p.startsWith(path+'/')).map(p=>({type:'file',name:p.split('/').at(-1)})));
});
try{
 await page.goto(process.env.JOURNAL_URL||'http://127.0.0.1:8765/journal/');
 await page.waitForFunction(()=>document.querySelector('#editor').contentEditable==='true');
 const date=await page.locator('#date').inputValue(),path=`journal/entries/${date.replaceAll('-','/').slice(0,-2)}${date.slice(-2)}.json`;
 assert.equal(await page.locator('.site-tabs a').count(),6);
 assert.match(await page.locator('body').evaluate(el=>getComputedStyle(el).fontFamily),/EB Garamond/);
 await page.screenshot({path:'/private/tmp/journal-desktop.png',fullPage:true});
 await page.locator('#title').fill('A day worth remembering');
 await page.locator('#editor').fill('A quiet morning, a good idea, and time to write. 今天 🌅');
 await page.waitForFunction(()=>document.querySelector('#status').textContent.includes('Draft saved'));
 assert.equal(writes.length,0);
 page.on('dialog',dialog=>dialog.accept());
 await page.reload();
 await page.waitForFunction(()=>document.querySelector('#status').textContent.includes('Restored local draft'));
 assert.match(await page.locator('#editor').innerText(),/今天/);
 await page.locator('#connect').click();await page.locator('#token').fill('test-only');
 await page.locator('#connection-form button[type=submit]').click();
 await page.waitForFunction(()=>document.querySelector('#status').textContent==='Saved on GitHub',{},{timeout:15000});
 assert.equal(writes.length,1);assert.equal(writes[0].path,path);
 assert.equal(await page.locator('#token').inputValue(),'');
 assert.equal(await page.evaluate(()=>Object.values(localStorage).some(v=>v.includes('test-only'))),false);
 // A pasted/uploaded image must land in GitHub before its referencing entry.
 png=Buffer.from(await page.evaluate(()=>{const c=document.createElement('canvas');c.width=40;c.height=30;c.getContext('2d').fillRect(0,0,40,30);return c.toDataURL('image/png').split(',')[1];}),'base64');
 await page.locator('#image-file').setInputFiles({name:'memory.png',mimeType:'image/png',buffer:png});
 await page.waitForFunction(()=>document.querySelector('#editor img'));
 await page.waitForFunction(()=>!document.querySelector('#save').disabled);
 await page.locator('#save').click();
 await page.waitForFunction(()=>document.querySelector('#status').textContent==='Saved on GitHub');
 assert.match(writes.at(-2).path,/journal\/media\//);assert.equal(writes.at(-1).path,path);
 assert.match(Buffer.from(writes.at(-1).body.content,'base64').toString(),/raw.githubusercontent.com/);
 assert.ok(!Buffer.from(writes.at(-1).body.content,'base64').toString().includes('data:image'));
 // Saved entry opens again after selecting a different calendar day.
 const other=await page.locator('#calendar button:not(.selected)').first().getAttribute('data-date');
 await page.locator(`#calendar button[data-date="${other}"]`).click();
 await page.waitForFunction(()=>document.querySelector('#status').textContent==='A fresh page for this day');
 await page.locator(`#calendar button[data-date="${date}"]`).click();
 await page.waitForFunction(()=>document.querySelector('#title').value==='A day worth remembering');
 // A second device updates the file; the old SHA must produce an explicit conflict.
 files.set(path,{sha:'other-device',content:Buffer.from(JSON.stringify({date,title:'From another device',html:'<p>Other device version</p>'})).toString('base64')});
 await page.locator('#editor').fill('My competing draft');await page.locator('#save').click();
 await page.waitForFunction(()=>!document.querySelector('#conflict').hidden);
 assert.equal(Buffer.from(files.get(path).content,'base64').toString().includes('Other device version'),true);
 await page.reload();
 await page.waitForFunction(()=>!document.querySelector('#conflict').hidden);
 assert.equal(await page.locator('#editor').innerText(),'My competing draft');
 assert.equal(await page.locator('#connect').innerText(),'Connect GitHub');
 await page.locator('#keep-draft').click();
 await page.locator('#connect').click();await page.locator('#token').fill('test-only');await page.locator('#connection-form button[type=submit]').click();
 await page.waitForFunction(()=>document.querySelector('#status').textContent==='Saved on GitHub',{},{timeout:15000});
 assert.equal(writes.at(-1).body.sha,'other-device');
 // A rejected write retains a recoverable draft, and retry succeeds.
 deny=true;await page.locator('#editor').fill('Kept through a failed sync');await page.locator('#save').click();
 await page.waitForFunction(()=>document.querySelector('#status').textContent.includes('denied'));
 assert.equal(await page.locator('#editor').innerText(),'Kept through a failed sync');
 deny=false;await page.locator('#save').click();await page.waitForFunction(()=>document.querySelector('#status').textContent==='Saved on GitHub');
 // Unsafe stored HTML cannot execute or insert third-party images.
 const cleaned=await page.evaluate(async()=>{const {cleanHTML}=await import('/journal/core.mjs');return cleanHTML('<script>alert(1)</script><img src="https://evil.invalid/a" onerror="alert(1)"><p style="color:red" onclick="alert(2)">Safe</p><svg onload="alert(3)"></svg>');});
 assert.equal(cleaned,'<p>Safe</p>');
 await page.setViewportSize({width:390,height:844});
 await page.screenshot({path:'/private/tmp/journal-mobile.png',fullPage:true});
 assert.equal(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),true);
 assert.deepEqual(errors,[]);
 console.log('PASS: shared style, calendar navigation, Unicode draft recovery, token lifecycle, autosave, image ordering, conflict/reload/resolve, rejected-save retry, HTML sanitization, mobile layout.');
}catch(error){console.error('UI status:',await page.locator('#status').textContent());await page.screenshot({path:'/private/tmp/journal-failure.png',fullPage:true});throw error;}finally{await browser.close();}
