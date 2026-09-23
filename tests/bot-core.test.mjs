import {test} from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import {retrieve,directMatch,answerIssues,citedSources} from '../js/bot-core.mjs';
const {chunks}=JSON.parse(fs.readFileSync(new URL('../data/bot-knowledge.json',import.meta.url)));
for(const [q,id,words] of [['Wuklab','wuklab',['currently','Yiying Zhang','January 2026']],['remzi','linuxguard-2025',['advised by Professor Remzi','Vinay Banakar']],['Vinay Banakar','linuxguard-2025',['ADSL']],['Michael Swift','os-inference',['honors','January to May 2026']],['Tell me about your publications','publication-list',['CASH','BEIT','Near-infrared']],['What is your GPA?','education',['3.96','3.82']]]){
 test('verified profile answer: '+q,()=>{const results=retrieve(q,chunks);assert.equal(results.length,1);assert.equal(results[0].id,id);for(const w of words)assert.ok(results[0].text.includes(w));});
}
test('unknown personal details do not pull random sources',()=>{assert.deepEqual(retrieve('What is Xuming’s favorite pizza topping?',chunks),[]);});
test('person plus unsupported fact is not treated as an exact profile question',()=>{assert.equal(directMatch('What is Remzi’s birthday?',chunks),undefined);});
test('research experience is distinct from publications',()=>{assert.equal(chunks.find(c=>c.id==='wuklab').source,'Research');assert.equal(chunks.find(c=>c.id==='paper-0').source,'Publication');});
test('only sources actually cited in the answer are displayed',()=>{const rows=[chunks[0],chunks[1]];assert.deepEqual(citedSources('A statement [2].',rows).map(x=>x.id),[rows[1].id]);assert.deepEqual(citedSources('Bad [8].',rows),[]);});
test('unsupported generated statistics require model revision',()=>{let rows=retrieve('wuklab',chunks);assert.ok(answerIssues('He improved performance by 9999% [1].',rows).length);});
test('new course knowledge does not retain the old planned CS537 claim',()=>{const c=chunks.find(c=>c.id==='courses');assert.ok(c.text.includes('Fall 2026'));assert.ok(c.text.includes('CS 577'));assert.ok(c.text.includes('Spring 2026'));assert.ok(!c.text.includes('Planned future courses:'));});
test('full NPU post and every current project are indexed',()=>{assert.ok(chunks.some(c=>c.source==='Blog'&&c.text.includes('partial sums')));assert.equal(chunks.filter(c=>c.source==='Project').length,24);});
test('removed blog listings are not fed back into retrieval',()=>{assert.ok(!chunks.some(c=>/nuc16-godot-igpu-interference|local-igpu-contention/.test(c.url)));});

test('paraphrased technical questions retrieve the current NPU evidence',()=>{const hits=retrieve('How does progressive compilation reduce waiting during NPU inference?',chunks);assert.ok(hits.length);assert.ok(hits.every(c=>/NPU|compil/i.test(c.text)));});

test('generated first-person impersonation requires model revision',()=>{const hits=retrieve('Wuklab',chunks);assert.ok(answerIssues('I spent time at WukLab [1].',hits).length);});

for(const q of ["what's your football experience",'what’s your football experience',"What's your experience playing football?",'Could you tell me a bit about your football background?','Do you play football?']) {
 test('natural football question: '+q,()=>{
  const hits=retrieve(q,chunks,{previousQuery:'research'});
  assert.deepEqual(hits.map(c=>c.id),['football']);
  assert.match(hits[0].text,/2023 NFL FLAG/);
  assert.equal(hits[0].url,'blog/posts/nfl-flag-football-championship.html');
 });
}
test('contractions also work for other profile topics',()=>{assert.equal(retrieve("What's your GPA?",chunks)[0]?.id,'education');});
test('broad research questions return a research overview',()=>{
 for(const q of ['research','What are your research experiences?',"What's your research background?"]) {
  const hits=retrieve(q,chunks);assert.deepEqual(hits.map(c=>c.id),['research-overview']);
  assert.match(hits[0].text,/WukLab/);assert.match(hits[0].text,/LinuxGuard/);
 }
});
test('normalizing questions does not invent unknown personal details',()=>{
 for(const q of ["What's your football jersey number?","What’s Remzi’s birthday?","What's your favorite pizza topping?"])assert.deepEqual(retrieve(q,chunks),[],q);
});

for(const [q,id] of [["what's your interest",'bio'],['what are your interests','bio'],['what are you interested in','bio'],["what's your hobby",'football'],['what are your hobbies','football']]) {
 test('profile topic, not an incidental blog word: '+q,()=>{assert.deepEqual(retrieve(q,chunks).map(c=>c.id),[id]);});
}
test('Vikranth is a collaborator and PhD candidate, not the faculty advisor',()=>{
 const results=retrieve('Vikranth Srivatsa',chunks);
 assert.equal(results[0].id,'vikranth');assert.match(results[0].text,/PhD candidate/);
 assert.match(results[0].text,/Yiying Zhang advises/);
});
test('observed model embellishments require revision',()=>{
 const hits=retrieve("what's your hobby",chunks);
 assert.ok(answerIssues('Xuming is a renowned expert in AI and plays flag football. [1]',hits).length);
 assert.deepEqual(answerIssues('His hobby is flag football. [1]',hits),[]);
});

test('first-person hobbies cannot impersonate Xuming',()=>{
 assert.ok(answerIssues('As Xuming, my hobby is flag football. I captained the team. [1]',retrieve('hobbies',chunks)).some(x=>x.includes('third person')));
});
