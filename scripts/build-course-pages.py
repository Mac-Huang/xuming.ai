#!/usr/bin/env python3
"""Render small, curated course pages while keeping the original site style."""
from pathlib import Path
from urllib.parse import quote
from html import escape
import json
ROOT=Path(__file__).resolve().parents[1]
data=json.loads((ROOT/'data/course-materials.json').read_text())
manifest=json.loads((ROOT/'courses/coursework-manifest.json').read_text())
GITHUB='https://github.com/Mac-Huang/xuming.ai/'
css='.material-group{margin:30px 0}.material-group h2{font-size:22px}.material-group li{margin:10px 0}.course-note{color:#666;font-size:14px}'
def nav(prefix):
 return '<nav class="site-tabs" aria-label="Main navigation">'+' <span aria-hidden="true">|</span> '.join(f'<a href="{prefix}{url}"'+(' aria-current="page"' if label=='Courses' else '')+f'>{label}</a>' for label,url in [('Home','index.html'),('Research','research.html'),('Projects','projects.html'),('Blog','blog.html'),('Courses','courses.html'),('Ask Me','bot.html')])+'</nav>'
for slug,course in data.items():
 base=ROOT/'courses'/slug
 sections=[];readme=[f'# {course["title"]}',course['description'],'## Materials']
 for section in course['sections']:
  links=[]
  for item in section['items']:
   path=item.get('file',item.get('folder'));target=base/'work'/path
   if not target.exists():raise FileNotFoundError(target)
   repo_path=f'courses/{slug}/work/{path}'
   github=('folder' in item or target.suffix.lower() in ['.md','.txt'])
   url=GITHUB+('tree/main/' if 'folder' in item else 'blob/main/')+quote(repo_path,safe='/') if github else 'work/'+quote(path,safe='/')
   attrs=' target="_blank" rel="noopener noreferrer"' if github else ''
   links.append(f'<li><a href="{escape(url,quote=True)}"{attrs}>{escape(item["label"])}</a></li>')
   readme.append(f'- [{item["label"]}](<{"work/"+path}>)')
  sections.append(f'<section class="material-group"><h2>{escape(section["title"])}</h2><ul>'+''.join(links)+'</ul></section>')
 count=sum(1 for x in manifest['files'] if x['path'].startswith(f'courses/{slug}/work/'))
 html=f'''<!DOCTYPE HTML>
<html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>{escape(course['title'])} - Xuming Huang</title>
<link rel="stylesheet" href="../../stylesheet.css?v=76dafacaf9"><link rel="icon" href="../../images/favicon.png">
<style>{css}</style><script src="../../js/site-links.js" defer></script></head><body>
<header class="page-header"><name>{escape(course['title'])}</name></header>{nav('../../')}
<main style="max-width:860px;margin:auto;padding:20px">
<p>{escape(course['description'])}</p>
<p><a href="../../courses.html">All courses</a> · <a href="{GITHUB}tree/main/courses/{slug}/work" target="_blank" rel="noopener noreferrer">Browse all coursework on GitHub</a></p>
{''.join(sections)}
<p class="course-note">Course handouts, papers, starter code, and libraries are credited to their original authors.</p>
</main></body></html>
'''
 (base/'index.html').write_text(html)
 (base/'README.md').write_text('\n\n'.join(readme)+'\n\n## Archive\n\nThe `work/` directory preserves the course working files and supporting assets. Original attribution and licenses remain in place. Alternate working copies are retained when their sources differ. Git histories, generated executables, caches, full reference textbooks, access passwords, and personal assessment exports are not included.\n')
readme=['# Coursework archive','Coursework and supporting materials organized by course. Browse the [Courses page](https://xuming.ai/courses.html) for selected notes, reports, and projects.','## Courses']
readme.extend(f'- [{c["title"]}]({slug}/README.md)' for slug,c in data.items())
readme+=['## Contents','Source files, test inputs and expected outputs, assignment materials, lecture notes, paper analyses, research reports, diagrams, and required supporting libraries. Working variants are preserved rather than silently overwritten.','`coursework-manifest.json` records the source-relative path, published path, size, and SHA-256 of each imported file. The original Courses.zip and all extracted files remain in the local Courses folder.','## Omitted from the public copy','Nested Git history, editor caches, generated build output, duplicate ZIPs, incomplete generated documentation, reference textbooks, course-access passwords, and personal assessment exports. This is a source archive, not a claim that every historical project compiles or passes its tests.','Course materials, papers, starter code, and dependencies retain their original authorship and licensing. No blanket license is applied to third-party coursework materials.']
(ROOT/'courses/README.md').write_text('\n\n'.join(readme)+'\n')
print('Rendered',len(data),'course pages')
