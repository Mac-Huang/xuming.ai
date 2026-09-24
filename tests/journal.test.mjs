import test from 'node:test';
import assert from 'node:assert/strict';
import { GitHub, GitHubError, encode, decode, entryPath, validDate, API } from '../journal/core.mjs';

test('dates reject rollover and traversal; entries use month folders',()=>{
  assert.equal(validDate('2026-02-30'),false);assert.equal(validDate('../2026-01'),false);
  assert.equal(validDate('2028-02-29'),true);assert.equal(entryPath('2026-09-24'),'journal/entries/2026/09/24.json');
  assert.throws(()=>entryPath('2026-13-01'));
});
test('Unicode entry text survives GitHub base64 round trip',()=>{
  const text='今天很开心 · café 🌅'; assert.equal(decode(encode(text)),text);
});
test('anonymous writes are blocked before making a request',async()=>{
  const github=new GitHub(()=>{throw new Error('Must not fetch');});
  await assert.rejects(github.save({date:'2026-09-24'},null),/Connect GitHub/);
});
test('save is limited to journal and includes the originally loaded SHA',async()=>{
  const calls=[];const github=new GitHub(async(url,options)=>{calls.push({url,options});return Response.json({content:{sha:'new'}});});github.token='test-only';
  await github.save({date:'2026-09-24',title:'Test',html:'<p>Hi</p>'},'original');
  assert.equal(calls[0].url,`${API}/contents/journal/entries/2026/09/24.json`);
  assert.equal(calls[0].options.headers.Authorization,'Bearer test-only');
  assert.equal(JSON.parse(calls[0].options.body).sha,'original');
  await assert.rejects(github.put('index.html','',null,'bad'),/Invalid/);
  await assert.rejects(github.put('journal/entries/../app.mjs','',null,'bad'),/Invalid/);
  assert.equal(calls.length,1);
});
test('conflicts surface without a retry that would overwrite another device',async()=>{
  let calls=0;const github=new GitHub(async()=>{calls++;return new Response('{}',{status:409});});github.token='test-only';
  await assert.rejects(github.save({date:'2026-09-24'},'old'),error=>error instanceof GitHubError&&error.status===409);
  assert.equal(calls,1);
});
test('missing entries are distinct from network and permission failures',async()=>{
  assert.deepEqual(await new GitHub(async()=>new Response('{}',{status:404})).get('2026-09-24'),{sha:null,entry:null});
  await assert.rejects(new GitHub(async()=>new Response('{}',{status:403})).get('2026-09-24'),/denied/);
  await assert.rejects(new GitHub(async()=>{throw new Error('offline');}).get('2026-09-24'),/Cannot reach/);
});
test('a failed access check forgets its token',async()=>{
  const github=new GitHub(async()=>Response.json({permissions:{push:false}}));
  await assert.rejects(github.connect('test-only'),/write access/);assert.equal(github.token,'');
});
test('month listing accepts only entry files and a valid month path',async()=>{
  const github=new GitHub(async()=>Response.json([{name:'24.json',type:'file'},{name:'notes.json',type:'file'},{name:'25.json',type:'dir'}]));
  assert.deepEqual(await github.month('2026-09'),['2026-09-24']);
  await assert.rejects(github.month('../bad'),/Invalid/);
});

test('reads both Markdown entries and existing HTML entries without rewriting',async()=>{
  for(const body of [{markdown:'## Today\n\n**Hello**',version:2},{html:'<p>Hello</p>',version:1}]) {
    let calls=0;
    const entry={date:'2026-09-24',title:'Journal',...body};
    const github=new GitHub(async(url,options)=>{calls++;assert.equal(options.method,undefined);return Response.json({sha:'existing',content:encode(JSON.stringify(entry))});});
    assert.deepEqual(await github.get(entry.date),{sha:'existing',entry});assert.equal(calls,1);
  }
});

test('GitHub distinguishes permission, validation, and rate-limit failures',async()=>{
  const permission=new GitHubError(403,{message:'Resource not accessible by personal access token'});
  assert.equal(permission.kind,'permission');assert.match(permission.message,/Contents to Read and write/);assert.equal(permission.retryAt,0);
  const validation=new GitHubError(422,{message:'Invalid content'});assert.equal(validation.kind,'request');
  const limited=new GitHubError(403,{message:'API rate limit exceeded',remaining:'0',reset:String(Math.ceil(Date.now()/1000)+90)});
  assert.equal(limited.kind,'rate-limit');assert.ok(limited.retryAt>Date.now()+89000);
  const secondary=new GitHubError(429,{retryAfter:'2'});assert.ok(secondary.retryAt>=Date.now()+1900);
  assert.ok(Number.isFinite(new GitHubError(429,{retryAfter:'invalid'}).retryAt));
  const github=new GitHub(async()=>Response.json({message:'Resource not accessible by personal access token test-only'},{status:403}));github.token='test-only';
  await assert.rejects(github.save({date:'2026-09-24'},null),error=>error.kind==='permission'&&!error.message.includes('test-only')&&error.message.includes('[redacted]'));
});

test('request preserves retry headers and video types accept uppercase MOV filenames',async()=>{
  const github=new GitHub(async()=>Response.json({message:'Secondary rate limit'},{status:403,headers:{'Retry-After':'2'}}));github.token='test-only';
  await assert.rejects(github.save({date:'2026-09-24'},null),error=>error.kind==='rate-limit'&&error.retryAt>Date.now()+1900);
  const {videoType,validMediaData,videoMarkup}=await import('../journal/media.mjs');
  assert.equal(videoType({name:'clip.MOV',type:''}).mime,'video/quicktime');
  assert.equal(videoType({name:'clip.mp4',type:''}).mime,'video/mp4');
  assert.equal(videoType({name:'file.pdf',type:'application/pdf'}),null);
  assert.equal(validMediaData('data:video/mp4;base64,YQ=='),true);
  assert.equal(validMediaData('data:text/html;base64,YQ=='),false);
  assert.match(videoMarkup('clip.MOV','https://example.com/clip.mov'),/Open \/ download clip.MOV/);
});
