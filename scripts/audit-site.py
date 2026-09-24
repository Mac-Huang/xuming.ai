#!/usr/bin/env python3
"""Check local HTML/JS links, assets and anchors; optional external GET checks."""
import concurrent.futures,html,json,re,subprocess,sys,tempfile,urllib.parse
from pathlib import Path
from html.parser import HTMLParser
ROOT=Path(__file__).resolve().parents[1]
class Parser(HTMLParser):
 def __init__(self): super().__init__();self.refs=[];self.ids=set()
 def handle_starttag(self,tag,attrs):
  a=dict(attrs)
  if a.get('id'):self.ids.add(a['id'])
  if tag=='a' and a.get('name'):self.ids.add(a['name'])
  for key in ('href','src','poster'):
   if a.get(key):self.refs.append((key,a[key]))
parsers={};refs=[]
for p in ROOT.rglob('*.html'):
 if any(x in p.parts for x in ('node_modules','.git')):continue
 parser=Parser();parser.feed(p.read_text());parsers[p.resolve()]=parser
 refs += [(p,k,u) for k,u in parser.refs]
# Data arrays power dynamically generated lists. Their URLs resolve from the site root.
for p in (ROOT/'data').glob('*.js'):
 s=p.read_text()
 refs += [(ROOT/'index.html',p.name,html.unescape(u)) for u in re.findall(r'''(?:["']?(?:image|thumbnail|cover|paper_url|code_url|project_url|data_url|demo_url|url)["']?)\s*:\s*["']([^"']+)["']''',s)]
dynamic_ids=set(re.findall(r'''["']?id["']?\s*:\s*["']([^"']+)["']''',(ROOT/'data/publications.js').read_text()))
missing=[];anchors=[];external={};local_count=0
for p,kind,raw in refs:
 if not raw or raw.startswith(('mailto:','tel:','javascript:','data:','blob:')):continue
 u=urllib.parse.urlsplit(raw)
 if u.netloc and u.netloc not in ('xuming.ai','www.xuming.ai'):
  external.setdefault(urllib.parse.urlunsplit((u.scheme or 'https',u.netloc,u.path,u.query,'')),set()).add((kind if kind.endswith('.js') else str(p.relative_to(ROOT))));continue
 if u.scheme not in ('','http','https'):continue
 decoded_path=urllib.parse.unquote(u.path)
 target=(ROOT/decoded_path.lstrip('/') if u.netloc or decoded_path.startswith('/') else p.parent/decoded_path).resolve() if decoded_path else p.resolve()
 if target.is_dir():target/='index.html'
 local_count+=1
 if not target.is_file():missing.append([str(p.relative_to(ROOT)),kind,raw]);continue
 frag=urllib.parse.unquote(u.fragment)
 if frag and target in parsers and frag not in parsers[target].ids and frag not in dynamic_ids and not frag.startswith(':~:'):
  anchors.append([str(p.relative_to(ROOT)),raw])
report={'html_pages':len(parsers),'local_references':local_count,'missing_local':missing,'missing_anchors':anchors,'external_urls':len(external)}
if '--external' in sys.argv:
 def check(item):
  url,sources=item
  try:
   result=subprocess.run(['curl','--location','--silent','--output','/dev/null','--max-time','12','--user-agent','Mozilla/5.0','--write-out','%{http_code} %{url_effective}',url],capture_output=True,text=True,timeout=15)
   code,_,final=result.stdout.partition(' ')
   return {'url':url,'status':int(code or 0),'final':final,'sources':sorted(sources)}
  except Exception as e:return {'url':url,'status':str(e),'sources':sorted(sources)}
 with concurrent.futures.ThreadPoolExecutor(max_workers=12) as pool:report['external']=list(pool.map(check,external.items()))
(Path(tempfile.gettempdir())/'xuming-site-audit.json').write_text(json.dumps(report,indent=2))
print(json.dumps({k:v for k,v in report.items() if k!='external'},indent=2))
if 'external' in report:print('External non-200:',json.dumps([x for x in report['external'] if x['status']!=200],indent=2))
sys.exit(bool(missing or anchors))
