import {test} from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import {generateReply} from '../js/bot-generation.mjs';
const {chunks}=JSON.parse(fs.readFileSync(new URL('../data/bot-knowledge.json',import.meta.url)));
function mockModel(answers){
 const requests=[];
 return {requests,engine:{chat:{completions:{create:async request=>{
  requests.push(structuredClone(request));
  const answer=answers[Math.min(requests.length-1,answers.length-1)];
  return (async function*(){
   for(const word of answer.split(/(?<= )/))yield {choices:[{delta:{content:word}}]};
   yield {choices:[],usage:{completion_tokens:20}};
  })();
 }}}}};
}
for(const [message,answer,source] of [
 ['WukLab','Xuming studies NPU compilers and inference runtimes at WukLab. [1]','wuklab'],
 ["what's your interest",'His research interests include AI systems, edge inference, and compilers. [1]','bio'],
 ["what's your hobby",'Xuming plays flag football and captained a national-championship team. [1]','football'],
 ["what's your football experience",'He captained the USST team that won the 2023 NFL FLAG championship. [1]','football'],
 ['What is his favorite pizza topping?','That detail is not in the available profile.',null]
])test('model generates the answer for '+message,async()=>{
 const {engine,requests}=mockModel([answer]);const tokens=[];
 const result=await generateReply({engine,message,chunks,onToken:(delta,full)=>{if(delta)tokens.push(full);}});
 assert.equal(requests.length,1);assert.equal(requests[0].stream,true);
 assert.equal(result.text,answer);assert.ok(tokens.length>1);
 assert.notEqual(tokens[0],answer);assert.equal(tokens.at(-1),answer);
 assert.deepEqual(result.sources.map(c=>c.id),source?[source]:[]);
 assert.equal(result.usage.completion_tokens,20);
});
test('no model never returns a stored answer',async()=>{
 await assert.rejects(generateReply({engine:null,message:'WukLab',chunks}),/not ready/);
});
test('model errors are visible instead of becoming a copied profile',async()=>{
 const engine={chat:{completions:{create:async()=>{throw Error('GPU failed');}}}};
 await assert.rejects(generateReply({engine,message:'WukLab',chunks}),/GPU failed/);
});
test('failed grounding asks the model to revise',async()=>{
 const {engine,requests}=mockModel(['He won in 2099. [1]','He captained the team that won in 2023. [1]']);
 const answer=await generateReply({engine,message:'football',chunks});
 assert.equal(requests.length,2);assert.match(requests[1].messages.at(-1).content,/Revise/);
 assert.equal(answer.text,'He captained the team that won in 2023. [1]');
});
test('a second invalid answer reports failure without an extractive fallback',async()=>{
 const {engine,requests}=mockModel(['He won in 2099. [1]']);
 await assert.rejects(generateReply({engine,message:'football',chunks}),/could not produce/);
 assert.equal(requests.length,2);
});

test('prior generated claims cannot contaminate a new topic',async()=>{
 const {engine,requests}=mockModel(['His research interests include systems for AI. [1]']);
 await generateReply({engine,message:"what's your interest",chunks,previousQuery:"what's your hobby",history:[{role:'assistant',content:'His hobby is flag football.'}]});
 assert.ok(!JSON.stringify(requests[0].messages).includes('flag football'));
 assert.ok(requests[0].messages.some(m=>m.content.includes('systems for AI')));
});
