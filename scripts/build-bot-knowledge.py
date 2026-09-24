#!/usr/bin/env python3
"""Rebuild bot knowledge from current public pages, data arrays, and curated resume facts.
Run with Python 3; Node must be on PATH (or set SITE_NODE).
"""
from pathlib import Path
from html.parser import HTMLParser
import hashlib,html,json,re,subprocess,os
ROOT=Path(__file__).resolve().parents[1]
class Blocks(HTMLParser):
 def __init__(self):super().__init__();self.blocks=[];self.parts=[];self.depth=0;self.skip=0;self.tag='';self.heading=''
 def handle_starttag(self,tag,attrs):
  if tag in ('script','style','nav'):self.skip+=1
  if self.skip:return
  if tag in ('br','hr','img','input','meta','link','source','wbr'):return
  if tag in ('p','li','h1','h2','h3','name','heading') and not self.depth:self.depth=1;self.parts=[];self.tag=tag
  elif self.depth:self.depth+=1
 def handle_endtag(self,tag):
  if tag in ('script','style','nav') and self.skip:self.skip-=1;return
  if self.skip:return
  if self.depth:
   self.depth-=1
   if self.depth==0:
    text=re.sub(r'\s+',' ',' '.join(self.parts)).strip()
    if self.tag in ('h1','h2','h3','name','heading'):self.heading=text
    elif len(text)>65:self.blocks.append((self.heading,text))
 def handle_startendtag(self,tag,attrs):pass
 def handle_data(self,s):
  if self.depth and not self.skip:self.parts.append(s)
def plain(s):return html.unescape(re.sub('<[^>]+>','',s))
node=os.environ.get('SITE_NODE','node')
js="const fs=require('fs'),vm=require('vm');let out={};for(const [f,n] of [['publications','publications'],['projects','projects'],['blog-posts','blogPosts']]){let c={};vm.runInNewContext(fs.readFileSync('data/'+f+'.js','utf8')+';this.items='+n+';',c);out[n]=c.items;}console.log(JSON.stringify(out));"
data=json.loads(subprocess.check_output([node,'-e',js],cwd=ROOT,text=True))
chunks=[]
def add(id,title,text,url,source='Profile',aliases=(),authoritative=False):
 chunks.append(dict(id=id,title=title,text=text,url=url,source=source,aliases=list(aliases),authoritative=authoritative))
add('bio','Current role and research interests','Xuming Huang is a Computer Sciences undergraduate at the University of Wisconsin–Madison, with graduation expected in May 2027. His interests are systems for AI, edge inference, operating systems, and AI compilers. His current research at WukLab, UC San Diego, focuses on NPU compilers and runtimes with Professor Yiying Zhang and PhD candidate Vikranth Srivatsa.','index.html',aliases=['who are you','who is xuming','about you','introduce yourself','current research','research focus','research interests','interests','interested in'],authoritative=True)
add('research-overview','Research experience','Xuming’s current research at WukLab, UC San Diego, focuses on efficient NPU compilers and inference runtimes. His other research includes LinuxGuard at ADSL, UW–Madison, using LLMs and compiler feedback to build Linux-kernel bug detectors; an honors project with Michael Swift measuring how filesystem activity affects AI inference; and CASH at USST, studying workload-aware CPU/GPU scheduling. He also coauthored studies of self-supervised laryngoscopic image classification and near-infrared tunable filters.','research.html',aliases=['research','research experience','research background','research projects','past research'],authoritative=True)
add('vikranth','Vikranth Srivatsa collaboration','Xuming works with Vikranth Srivatsa, a PhD candidate at WukLab, UC San Diego, on NPU compilers and runtimes. Professor Yiying Zhang advises the research.','index.html',aliases=['vikranth','vikranth srivatsa','srivatsa','wuklab collaborator','collaborators','work with'],authoritative=True)
add('advisors','Research advisors','Xuming’s current advisor at WukLab, UC San Diego, is Professor Yiying Zhang. His LinuxGuard advisors at ADSL, UW–Madison, were Professor Remzi Arpaci-Dusseau and Dr. Vinay Banakar. Professor Michael Swift advised his honors operating-systems project. Professor Xing Hu advised his USST scheduling research.','research.html',aliases=['advisors','research advisors','supervisors','mentors'],authoritative=True)
add('education','Education','Xuming studies for a B.S. in Computer Sciences at UW–Madison (January 2025–May 2027 expected), GPA 3.96/4.00. He attended Stanford as a visiting undergraduate in Summer 2025 (June–August), GPA 4.00/4.00. He previously studied Computer Science and Technology at the University of Shanghai for Science and Technology (September 2021–July 2024), GPA 3.82/4.50.','cv/Academic_Resume.pdf',aliases=['education','gpa','university','universities','graduation','graduate','degree','academic background'],authoritative=True)
for p in data['publications']:
 aliases={'wuklab':['What research are you doing at WukLab?','wuklab','yiying','zhang','ucsd','uc san diego','edge ai','npu'], 'linuxguard-2025':['What research did you do with Professor Remzi Arpaci-Dusseau?','linuxguard','remzi','arpaci','dusseau','vinay','banakar','adsl','security'], 'os-inference':['michael swift','swift','filesystem','honors project'], 'cash':['cash','xing hu','scheduling','usst research'], 'beit-laryngoscopy':['beit','laryngoscopy','laryngoscopic','medical imaging'], 'near-infrared-filter':['near infrared','optical filter','liquid crystals','tunable filter']}[p['id']]
 intro={'wuklab':'Xuming is currently an undergraduate researcher at WukLab, UC San Diego, advised by Professor Yiying Zhang, since January 2026.', 'linuxguard-2025':'Xuming worked on LinuxGuard at The ADvanced Systems Laboratory (ADSL), UW–Madison, from January to November 2025, advised by Professor Remzi Arpaci-Dusseau and Dr. Vinay Banakar. Remzi was his research advisor.', 'os-inference':'Xuming completed an honors course research project with Professor Michael Swift at UW–Madison from January to May 2026.', 'cash':'Xuming contributed as a coauthor and undergraduate researcher advised by Professor Xing Hu at USST, January 2024–September 2026.', 'beit-laryngoscopy':'Xuming is a coauthor of the BEIT-style laryngoscopic image classification paper published at ICFTIC in 2025.', 'near-infrared-filter':'Xuming is a coauthor of the near-infrared tunable filter paper published in Micro & Nano Letters in 2025.'}[p['id']]
 add(p['id'],p['title'],intro+(' He works with Vikranth Srivatsa, a PhD candidate at WukLab.' if p['id']=='wuklab' else '')+' He '+p['abstract'][0].lower()+p['abstract'][1:],p['paper_url'],'Research',aliases,True)
add('teaching','Teaching and service','Xuming is an In-Class Peer Coach (ICPC) for ECE 252 at UW–Madison, September–December 2026. He supports discussion sessions and holds office hours.','index.html#teaching',aliases=['teaching','peer coach','icpc','ece 252','service'],authoritative=True)
add('skills','Technical skills','Languages: Python, C/C++, Java, JavaScript, Verilog, assembly, and Swift. Systems and tools: Linux, OpenVINO, LLVM/Clang, Git, Docker, GDB, and Valgrind. Methods: performance measurement, compiler/runtime experiments, model fine-tuning, and correctness evaluation.','cv/Academic_Resume.pdf',aliases=['skills','programming languages','tools'],authoritative=True)
add('work','Cool AI internship','Xuming was a Technical R&D and Product Development Intern at Cool AI Technology in Shanghai, July–September 2024. He redesigned the web interface with Next.js and Tailwind CSS, improving page load time by 45% and user engagement by 30% across 5,000+ daily active users. He built a FastAPI backend for LLM integration, handling 1,000+ concurrent requests and reducing API response time from 3 seconds to 800 milliseconds. He deployed prompted agents for AI-Hub, serving 20+ enterprise clients and generating $10K in new revenue in the first month.','cv/Academic_Resume.pdf',aliases=['coolai','cool ai','internship','work experience'],authoritative=True)
add('awards','Honors and awards',"Xuming received the Dean’s List honor at UW–Madison and the Presidential Scholarship at USST (Top 1%).",'cv/Academic_Resume.pdf',aliases=['honors','awards','scholarship','deans list'],authoritative=True)
add('learning-resources','Algorithms and AI Systems Learning Resources','Since January 2024, Xuming has maintained open-source algorithms and AI systems learning resources: 20+ algorithm and data-structure implementations across 6+ topics, with visualizations and practice templates, reaching 100+ GitHub stars. He implemented Transformer and GPT-2 from scratch in PyTorch, including multi-head attention, encoder-decoder architecture, optimization, and training.','projects.html',aliases=['algorithms','learning resources','transformer','gpt','gpt2','gpt 2','github stars'],authoritative=True)
add('heap','Heap Allocator','Xuming built a heap allocator during Stanford Summer Session, June–August 2025. He implemented free-block management, coalescing, and boundary tags, and explored fragmentation and allocator behavior through randomized stress tests and memory-debugging tools.','demos/heap-allocator.html',aliases=['heap','allocator','heap allocator'],authoritative=True)
add('stanford','Stanford Summer 2025','At Stanford in Summer 2025, Xuming took CS107 Computer Organization & Systems (A+, 99/100) and CS161 Design and Analysis of Algorithms (A, 93/100). His CS107 work included a heap allocator and responsible disclosure of AFS security issues, working with Alex Keller.','blog/posts/stanford-summer-2025.html',aliases=['stanford','cs107','cs 107','cs161','cs 161','afs','alex keller'],authoritative=True)
add('contact','Contact','Xuming’s public academic email is xuming@cs.wisc.edu. His GitHub account is Mac-Huang and his website is xuming.ai.','index.html',aliases=['contact','email','github','reach you'],authoritative=True)
add('football','Flag football','Xuming captained the USST Earthmoving Vehicles flag football team, which won the 2023 NFL FLAG national championship.','blog/posts/nfl-flag-football-championship.html',aliases=['football','flag football','football experience','football background','experience playing football','play football','football team','sports','sports experience','hobbies','free time','outside research','champion','championship'],authoritative=True)
# Actual publication entries are separate from research appointments.
s=(ROOT/'research.html').read_text();section=s[s.index('<section id="publications"'):]
summary=[]
for i,article in enumerate(re.findall(r'<article class="publication-entry">(.*?)</article>',section,re.S)):
 title=plain(re.search('<h3>(.*?)</h3>',article,re.S)[1]);paras=re.findall('<p>(.*?)</p>',article,re.S);doi=re.search('href="(https://doi.org/[^\"]+)"',article)[1]
 text=title+'. '+'. '.join(plain(x) for x in paras[:2])+'.'
 add('paper-'+str(i),title,text,doi,'Publication',[],True);summary.append(text)
add('publication-list','Published papers','Xuming’s publications, newest first: '+' '.join(summary),'research.html#publications','Publication',['publications','papers','published papers','publication'],True)
# Every project, including less prominent projects.
for p in data['projects']:
 add('project-'+p['id'],p['title'],p['title']+'. '+p['description']+' Technologies: '+p['tech']+'. First listed on the website: '+p['date']+'.',p['demo_url'] or p['code_url'],'Project')
# Full prose from the current course page and listed blogs, not just excerpts.
for filename,title,source in [('courses.html','Coursework','Courses')]+[(b['url'],b['title'],'Blog') for b in data['blogPosts']]:
 s=(ROOT/filename).read_text()
 if source=='Blog':
  start=s.find('<div class="blog-content">')
  if start>=0:s=s[start:]
 parser=Blocks();parser.feed(s)
 for i,(heading,text) in enumerate(parser.blocks):
  if 'Feel free to clone' in text or 'Back to Blog' in text:continue
  add(f'{filename}-{i}',title+(' — '+heading if heading else ''),text,filename,source)
course_text=[]
for group in re.findall(r'<section>(.*?)</section>',(ROOT/'courses.html').read_text(),re.S):
 title=plain(re.search('<h2[^>]*>(.*?)</h2>',group,re.S)[1]);names=[plain(x) for x in re.findall('<h3>(.*?)</h3>',group,re.S)];course_text.append(title+': '+', '.join(names)+'.')
add('courses','Coursework',' '.join(course_text)+' The site lists no confirmed future course plan beyond these courses.','courses.html','Courses',['courses','coursework','classes','course plans'],True)
# Content-addressed version prevents stale knowledge after same-length edits.
version=hashlib.sha256(json.dumps(chunks,sort_keys=True).encode()).hexdigest()[:16]
(ROOT/'data/bot-knowledge.json').write_text(json.dumps({'version':version,'updated':'2026-09-23','chunks':chunks},ensure_ascii=False,indent=2)+'\n')
print(f'Built {len(chunks)} chunks; version {version}')
