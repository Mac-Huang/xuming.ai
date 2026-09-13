"""Bounded page-touch loop; persistent mapping, no artificial unmap faults."""
import argparse,json,mmap,os,pathlib,resource,signal,time
import numpy as np
import psutil
p=argparse.ArgumentParser();p.add_argument('--file',required=True);p.add_argument('--gib',type=int,required=True);p.add_argument('--folder',required=True);p.add_argument('--seconds',type=int,default=600);a=p.parse_args()
folder=pathlib.Path(a.folder);running=True

def stop(*_):
 global running
 running=False
signal.signal(signal.SIGTERM,stop);signal.signal(signal.SIGINT,stop)
size=a.gib*1024**3;block=64*1024**2;page=os.sysconf('SC_PAGE_SIZE');rng=np.random.default_rng(17)
start=time.monotonic();passes=0;pages=0;checksum=0;last=0
with open(a.file,'rb') as fd,mmap.mmap(fd.fileno(),size,access=mmap.ACCESS_READ) as mm,(folder/'thrash.jsonl').open('w') as log:
 def emit(**kw):
  r=resource.getrusage(resource.RUSAGE_SELF)
  log.write(json.dumps(dict(time=time.time(),elapsed_s=time.monotonic()-start,passes=passes,pages_touched=pages,working_set_bytes=size,rss_bytes=psutil.Process().memory_info().rss,minflt=r.ru_minflt,majflt=r.ru_majflt,checksum=checksum,**kw))+'\n');log.flush()
 emit(started=True,page_bytes=page,block_bytes=block)
 while running and time.monotonic()-start<a.seconds:
  for index in rng.permutation(size//block):
   if not running or time.monotonic()-start>=a.seconds:break
   view=np.ndarray((block//page,),dtype=np.uint64,buffer=mm,offset=int(index)*block,strides=(page,))
   checksum^=int(np.bitwise_xor.reduce(view));del view;pages+=block//page
   if time.monotonic()-last>=.5:emit();last=time.monotonic()
  else:
   passes+=1
   if passes==1:
    emit(first_pass_complete=True);(folder/'thrash.ready').touch()
 emit(finished=True)
