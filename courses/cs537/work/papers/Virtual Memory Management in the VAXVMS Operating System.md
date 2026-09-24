# Virtual Memory Management in the VAX/VMS Operating System

**Constraints → Concerns → Mechanisms → Lessons**

Mini-computer systems provide inadequate hardware support for VM operations while simultaneously needing to support a wide variety of hardware implementations. This creates a fundamental design tension: weak CPUs and slow moving-head disks make sophisticated VM policies expensive, while mixed workloads (real-time, timesharing, batch) demand both predictability and efficiency. Therefore, VAX/VMS is an OS designed to be able to operate on hardware configurations having small, inexpensive CPUs, slow moving-head disks, and small memories.

To be more specific, according to the author, there are four system-level concerns that the VAX/VMS memory management design must mitigate:

1. Loss of isolation and fairness, where a heavily faulting process can degrade the performance of other processes in the system
2. High startup and restart costs caused by programs faulting pages one at a time
3. Excessive disk I/O pressure due to frequent paging on slow moving-head disks
4. High CPU overhead in the VM subsystem from maintaining and searching page management data structures

Thus, the memory management design is split into two cooperating components: the **pager**, which handles fine-grained page faults within a process, and the **swapper**, which manages coarse-grained movement of entire processes to control global memory pressure.

To limit concern 1, VAX/VMS adopts a process-local page replacement policy rather than a global one. Instead of allowing one process’s faulting behavior to evict pages belonging to others, each process is confined to its own resident-set list managed as a fixed-size FIFO queue. When this limit is reached, the pager evicts pages only from that process and places them on the global free or modified page lists, which act as a cache for recently removed pages and lead to two key benefits: 

​	(a) if a page is faulted again shortly after eviction, it can be recovered quickly from the free or modified list without disk I/O, reducing VM bookkeeping overhead (concern 4); and 

​	(b) it enables efficient clustered disk I/O by batching the write-back of dirty pages, substantially lowering paging traffic and disk pressure (concern 3).

This delayed reuse reduces VM bookkeeping overhead and enables efficient clustered disk I/O, particularly for writing dirty pages.

Clustering further reduces startup and paging cost (concern 2) by amortizing disk seek latency (which dominates paging cost on slow moving-head disks): when a page fault occurs, the pager reads or writes multiple contiguous pages using a single I/O operation.  Thanks to executable files typically laid out contiguously on disk by the linker, this approach effectively prefetches pages likely to be used soon.

One-page report is far from capturing the full wisdom of the VAX/VMS design; the goal here is not to restate mechanisms, but to extract the underlying design lessons embodied in those choices, but the high-level ideas of designing that I learned are:

1. A central design lesson illustrated here is that memory hierarchy and locality serve as a bridge between processor cost and storage latency. The free/modified list in this case plays the role of cache between RAM and disk residing in different processes.
2. System design inevitably involves trade-offs, but their impact depends on context. In other words, different machines emphasize different bottlenecks, and effective designs exploit strengths while mitigating weaknesses.

I believe a trade-off in VAX/VMS is that strong isolation and fairness are achieved at the cost of reduced per-process memory flexibility. When many processes run concurrently, each is constrained by its resident-set limit, which can lead to higher per-process page fault rates even if aggregate memory pressure is moderate.

-----

*Beyond the paper, I also met some obstacles and questions:

1. I understand the learning curve of reading papers. I spent 12 hours on reading this one. Is it too long?
2. When reading a paper which is some topic not familiar with, how deep should I go? E.g. GPU kernel 
3. How to tell if a paper is good or bad? Each one seems to make sense (self-justification)