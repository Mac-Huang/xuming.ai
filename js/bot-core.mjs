// Pure retrieval and citation functions, shared by the browser and regression tests.
const STOP = new Set('a an the and or of on in at to for from with by as is are was were be been am do does did has have had i me my mine you your yours he his him she her they their them it its this that these those xuming huang tell about what which who how when where can could would please know more some any all only also me during explain describe taking taken tell little bit briefly share give professor prof doctor dr'.split(' '));
for(const word of 'done doing result results outcome outcomes achievement achievements'.split(' '))STOP.add(word);
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
// Bot identity is runtime metadata, not a fact to look up in Xuming's biography.
export function requestKind(query) {
 const q=normalize(query).replace(/\bur\b/g,'your').replace(/\bu\b/g,'you');
 if(/^(hi|hello|hey|hiya|good morning|good evening|thanks|thank you)( there| bot| xuming bot)?$/.test(q))return 'social';
 if(/^(what is|whats|tell me|tell me about) your name$|^who are you$|^introduce yourself$/.test(q))return 'identity';
 if(/^(what|which) (?:is |are )?(?:the |your |this )?(?:ai |language |llm )?model(?: is this| are you| are you using| do you use| powers you)?$|^what are you running on$/.test(q))return 'model';
 if(/^(what can you do|how do you work|what can i ask you)$/.test(q))return 'capabilities';
 return 'profile';
}
export function resolveQuery(query,previousQuery='') {
 if(previousQuery && requestKind(query)==='profile' &&
  (/^(and |what about |how about |tell me more|more details|why\??$|how\??$)/i.test(query) && tokens(query).length<=3 ||
   /\b(it|that|this project|that project|which one)\b/i.test(query) && tokens(query).length<=7))return previousQuery+' '+query;
 return query;
}
export function retrieve(query,chunks,{previousQuery='',limit=4}={}) {
 if(requestKind(query)!=='profile')return [];
 query=resolveQuery(query,previousQuery);
 if(/^(?:who is|tell me about|about) xuming(?: huang)?$/.test(normalize(query)))return chunks.filter(c=>c.id==='bio');
 // "Best" is a request for a reasoned recommendation, not a keyword that
 // every project description must contain. Supply contrasting candidates.
 if(/\b(project|projects)\b/i.test(query) &&
  (/\b(best|strongest|impressive|recommend|favorite|favourite)\b/i.test(query) ||
   /^(?:tell me (?:about )?|what are |list |show me )?(?:all |your |his |xuming s |xuming )?(?:projects|project portfolio)(?: xuming has done)?$/i.test(normalize(query)))) {
  return ['research-overview','wuklab','linuxguard-2025','learning-resources'].map(id=>chunks.find(c=>c.id===id)).filter(Boolean).slice(0,limit);
 }
 const direct=directMatch(query,chunks);
 if(direct)return [{...direct,score:100}];
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
export function answerIssues(answer,retrieved,{kind='profile'}={}) {
 const issues=[];
 if(!answer.trim())issues.push('The answer is empty.');
 if(kind==='profile' && /\b(?:I (?:am|have been|worked|work|studied|developed|built|spent|captained|played|led)|my|mine|as Xuming)\b/i.test(answer))issues.push('Speak about Xuming in the third person.');
 const ids=[...answer.matchAll(/\[(\d+)\]/g)].map(m=>Number(m[1]));
 if(ids.some(i=>i<1||i>retrieved.length))issues.push('Use only the supplied source numbers.');
 if(retrieved.length&&!ids.length)issues.push('Answer from the relevant evidence and cite it with [1] or the matching source number.');
 const sources=citedSources(answer,retrieved);
 const evidence=normalize(sources.map(c=>c.text).join(' '));
 const embellishments=answer.match(/\b(?:renowned|expert|talented|passionate|prestigious|world.class)\b/gi)||[];
 if(embellishments.some(word=>!evidence.split(' ').includes(normalize(word))))issues.push('Remove unsupported praise or reputation claims; describe only the facts in the sources.');
 // This catches unsupported statistics, not every possible semantic error.
 const numbers=text=>(text.match(/\d+(?:[,.]\d+)*/g)||[]).map(n=>Number(n.replaceAll(',','')));
 const facts=new Set(numbers(sources.map(c=>c.text).join(' ')));
 if(kind==='profile' && numbers(answer.replace(/\[\d+\]/g,'')).some(n=>!facts.has(n)))issues.push('Remove numerical claims that are absent from the cited evidence.');
 return issues;
}
