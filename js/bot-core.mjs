// Pure retrieval and citation functions, shared by the browser and regression tests.
const STOP = new Set('a an the and or of on in at to for from with by as is are was were be been am do does did has have had i me my mine you your yours he his him she her they their them it its this that these those xuming huang tell about what which who how when where can could would please know more some any all only also me during explain describe taking taken tell little bit briefly share give professor prof doctor dr'.split(' '));
export const normalize = text => text.toLowerCase().normalize('NFKD')
 .replace(/[’‘]/g,"'")
 // Expand conversational contractions before punctuation removal. Otherwise
 // "what's" becomes an unknown, heavily weighted keyword that hides real matches.
 .replace(/\b(what|who|where|when|how|why|that|there|it)'s\b/g,'$1 is')
 .replace(/\b([a-z]+)'re\b/g,'$1 are').replace(/\b([a-z]+)'ve\b/g,'$1 have')
 .replace(/\bi'm\b/g,'i am').replace(/\b([a-z]+)'ll\b/g,'$1 will')
 .replace(/\b([a-z0-9]+)'s\b/g,'$1')
 .replace(/[^a-z0-9]+/g,' ').trim();
const WORDS = {compilation:'compile',compiling:'compile',compiled:'compile',compiles:'compile',waiting:'wait',waits:'wait',pause:'wait',pauses:'wait',reduced:'reduce',reduces:'reduce',reduction:'reduce',reducing:'reduce',courses:'course',classes:'course',class:'course',advises:'advisor',advised:'advisor',advisors:'advisor',advising:'advisor',supervisor:'advisor',supervisors:'advisor',mentor:'advisor',mentors:'advisor',publications:'publication',papers:'paper',projects:'project',runtimes:'runtime'};
Object.assign(WORDS,{experiences:'experience',playing:'play',played:'play',plays:'play',working:'work',worked:'work',works:'work',interests:'interest',interested:'interest',hobbies:'hobby',sports:'sport'});
export const tokens = text => [...new Set(normalize(text).split(' ').filter(t=>t.length>1&&!STOP.has(t)).map(t=>WORDS[t]||t))];
const sameTopic = (query, alias) => {
 const q=tokens(query), a=tokens(alias);
 return q.length>0 && a.length>0 && q.every(t=>a.includes(t)) && a.every(t=>q.includes(t));
};
export function directMatch(query,chunks) {
 return chunks.find(c=>c.authoritative && c.aliases.some(a=>sameTopic(query,a)));
}
export function retrieve(query,chunks,{previousQuery='',limit=4}={}) {
 const direct=directMatch(query,chunks);
 if(direct)return [{...direct,score:100}];
 // A short follow-up reuses the last user topic, never an assistant's generated claims.
 if(previousQuery && /^(and |what about |how about |tell me more|more details|why\??$|how\??$)/i.test(query) && tokens(query).length<=3)query=previousQuery+' '+query;
 const terms=tokens(query);if(!terms.length)return [];
 const docs=chunks.map(c=>new Set(tokens(c.title+' '+c.text+' '+c.aliases.join(' '))));
 const idf=new Map(terms.map(t=>[t,Math.log(1+chunks.length/(1+docs.filter(d=>d.has(t)).length))]));
 const weighted=terms.reduce((sum,t)=>sum+idf.get(t),0);
 const scored=chunks.map((c,i)=>{
  const hits=terms.filter(t=>docs[i].has(t));
  const coverage=hits.reduce((s,t)=>s+idf.get(t),0)/weighted;
  const title=new Set(tokens(c.title+' '+c.aliases.join(' ')));
  const score=hits.reduce((s,t)=>s+idf.get(t)*(title.has(t)?2:1),0)*(c.authoritative?1.3:1);
  return {...c,score,coverage,hits:hits.length};
 }).filter(c=>c.coverage>=0.48 && c.hits>0).sort((a,b)=>b.score-a.score);
 if(!scored.length)return [];
 const seen=new Set();
 return scored.filter(c=>c.score>=scored[0].score*0.62).filter(c=>{
  // Avoid several near-identical citations from one page crowding out evidence.
  const key=c.url+'|'+(c.authoritative?'primary':'body');if(seen.has(key))return false;seen.add(key);return true;
 }).slice(0,limit);
}
export function citedSources(answer,retrieved) {
 const ids=[...answer.matchAll(/\[(\d+)\]/g)].map(m=>Number(m[1]));
 if(!ids.length || ids.some(i=>i<1||i>retrieved.length))return [];
 return [...new Set(ids)].map(i=>({...retrieved[i-1],citation:i}));
}
export function answerIssues(answer,retrieved) {
 const issues=[];
 if(!answer.trim())issues.push('The answer is empty.');
 if(/\bI (?:am|have been|worked|work|studied|developed|built|spent)\b/i.test(answer))issues.push('Speak about Xuming in the third person.');
 const ids=[...answer.matchAll(/\[(\d+)\]/g)].map(m=>Number(m[1]));
 if(ids.some(i=>i<1||i>retrieved.length))issues.push('Use only the supplied source numbers.');
 if(retrieved.length&&!ids.length)issues.push('Answer from the relevant evidence and cite it with [1] or the matching source number.');
 const sources=citedSources(answer,retrieved);
 // This catches unsupported statistics, not every possible semantic error.
 const numbers=text=>(text.match(/\d+(?:[,.]\d+)*/g)||[]).map(n=>Number(n.replaceAll(',','')));
 const facts=new Set(numbers(sources.map(c=>c.text).join(' ')));
 if(numbers(answer.replace(/\[\d+\]/g,'')).some(n=>!facts.has(n)))issues.push('Remove numerical claims that are absent from the cited evidence.');
 return issues;
}
