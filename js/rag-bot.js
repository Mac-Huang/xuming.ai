import {generateReply} from './bot-generation.mjs?v=20260923-3';
const MODEL_OPTIONS=[
 {id:'Llama-3.2-1B-Instruct-q4f16_1-MLC',name:'Llama 3.2 1B',label:'Fast · Llama 3.2 1B (~0.9 GB GPU memory)'},
 {id:'Llama-3.2-3B-Instruct-q4f16_1-MLC',name:'Llama 3.2 3B',label:'Better · Llama 3.2 3B (~2.3 GB GPU memory)'}
];
let knowledge=null,engine=null,currentModel=null,busy=false,loading=false,previousQuery='',history=[];
async function loadKnowledge(){
 if(knowledge)return knowledge;
 const response=await fetch(new URL('../data/bot-knowledge.json',import.meta.url),{cache:'no-cache'});
 if(!response.ok)throw Error('Could not load the current profile. Please refresh.');
 knowledge=await response.json();return knowledge;
}
export async function initBot(modelId=MODEL_OPTIONS[0].id,progress){
 if(!MODEL_OPTIONS.some(m=>m.id===modelId))throw Error('Unsupported model');
 if(busy||loading)throw Error('Wait for the current operation before changing models.');
 loading=true;
 try{
  await loadKnowledge();
  if(!navigator.gpu)throw Error('WebGPU is unavailable. Use a WebGPU-enabled browser to run the local language model.');
  progress?.({text:'Loading the selected language model…',pct:10});
  if(engine){const previous=engine;engine=null;currentModel=null;await previous.unload();}
  const {CreateMLCEngine}=await import('https://esm.run/@mlc-ai/web-llm@0.2.85');
  engine=await CreateMLCEngine(modelId,{initProgressCallback:r=>progress?.({text:r.text,pct:10+Math.round((r.progress||0)*90)})},{context_window_size:4096});
  currentModel=modelId;
  progress?.({text:`Ready · ${modelName()}`,pct:100});
 }catch(error){engine=null;currentModel=null;throw error;}
 finally{loading=false;}
}
function modelName(){return MODEL_OPTIONS.find(m=>m.id===currentModel)?.name||'Language model';}
export async function ask(message,{onToken,onSources,onPhase}={}){
 if(busy)throw Error('Please wait for the current answer.');
 if(!engine||loading)throw Error('The language model is not ready. Please wait or retry loading it.');
 busy=true;
 const started=performance.now();
 try{
  const result=await generateReply({engine,message,chunks:knowledge.chunks,previousQuery,history,onToken,onPhase});
  previousQuery=message;
  history=[...history,{role:'user',content:message},{role:'assistant',content:result.text}].slice(-4);
  onSources?.(result.sources);
  return {...result,model:modelName(),elapsedMs:performance.now()-started};
 }finally{busy=false;}
}
window.RagBot={init:initBot,ask,isReady:()=>Boolean(engine)&&!loading,listModels:()=>MODEL_OPTIONS,reset:()=>{previousQuery='';history=[];},isBusy:()=>busy,modelName};
