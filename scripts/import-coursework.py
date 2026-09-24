#!/usr/bin/env python3
"""Import the course working files, without histories, caches, or private records."""
from pathlib import Path
from collections import Counter
import argparse,hashlib,json,shutil
parser=argparse.ArgumentParser()
parser.add_argument('source',type=Path)
args=parser.parse_args()
root=Path(__file__).resolve().parents[1]
source=args.source.resolve()
metadata={'.git','.idea','.settings','__pycache__','.pytest_cache','.mypy_cache','.ruff_cache','node_modules','venv','.venv'}
generated_dirs={'build','tests-out','output'}
generated_ext={'.o','.obj','.sym','.class','.pyc','.pyo','.img','.vcd','.vvp','.fst','.a','.exe','.d','.i'}
textbooks={'CS354/Computer Systems.pdf','CS552/Computer Organization and Design.pdf','CS352/Verilog_guide_cohen.pdf','CS537/Operating Systems.pdf','CS537/xv6.pdf'}
counts=Counter();entries=[]
def omit(p,rel):
 if any(x in metadata for x in rel.parts):return 'repository or editor metadata'
 if any(x in generated_dirs for x in rel.parts):return 'generated output'
 if p.name in {'.DS_Store','desktop.ini','.classpath','.project'}:return 'desktop or IDE metadata'
 if str(rel)=='ECE252/Exercise_Passwords.docx':return 'course access credentials'
 if rel.parts[:2]==('CS300','Review'):return 'personal assessment exports'
 if str(rel) in textbooks:return 'reference textbook'
 if rel.parts[:3]==('CS300','P04CalendarManager','P04 Monthy Calendar') and p.suffix.lower()=='.html':return 'generated documentation'
 if p.suffix.lower()=='.zip':return 'duplicate archive'
 if p.suffix.lower() in generated_ext:return 'generated output'
 with p.open('rb') as f:magic=f.read(4)
 if magic==b'\x7fELF' or magic in [b'\xcf\xfa\xed\xfe',b'\xfe\xed\xfa\xcf',b'\xce\xfa\xed\xfe']:return 'compiled executable'
 return None
for course in sorted(source.iterdir()):
 if not course.is_dir() or not course.name.startswith(('CS','ECE','ESL')):continue
 for p in sorted(course.rglob('*')):
  if not p.is_file():continue
  if p.is_symlink():raise ValueError('Unexpected symlink: '+str(p))
  rel=p.relative_to(source);reason=omit(p,rel)
  if reason:counts[reason]+=1;continue
  target=root/'courses'/course.name.lower()/'work'/p.relative_to(course)
  if target.exists() and target.read_bytes()!=p.read_bytes():raise ValueError('Existing different file: '+str(target))
  target.parent.mkdir(parents=True,exist_ok=True)
  if not target.exists():shutil.copy2(p,target)
  target.chmod(target.stat().st_mode | 0o200)
  entries.append({'source':str(rel),'path':str(target.relative_to(root)),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
manifest={'files':entries,'omitted_counts':dict(counts),'note':'Original files remain in the local Courses folder and original ZIP. The repository contains coursework sources, test fixtures, notes, papers, reports, and supporting assets.'}
(root/'courses/coursework-manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
print(json.dumps({'files':len(entries),'bytes':sum(x['bytes'] for x in entries),'omitted':dict(counts),'courses':dict(Counter(x['source'].split('/')[0] for x in entries))},indent=2))
