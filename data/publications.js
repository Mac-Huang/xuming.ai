// Website data; factual research and project claims follow Resume.pages.
const publications = [
  {
    "id": "wuklab",
    "title": "Edge AI Systems Optimization",
    "authors": "<strong>Xuming Huang</strong> · advised by Prof. Yiying Zhang",
    "venue": "Undergraduate Researcher · WukLab, UC San Diego · Jan. 2026–present",
    "year": 2026,
    "image": "images/papers/wuklab/edge-ai-processing-array.png",
    "paper_url": "blog/posts/npu-jit-static-shapes.html",
    "paper_label": "blog post",
    "code_url": "https://github.com/openvinotoolkit/npu_compiler/pull/348",
    "code_label": "compiler PR #348",
    "selected": true,
    "category": "ongoing",
    "abstract": "Developed a JIT NPU runtime that overlaps CPU graph compilation with NPU inference and grows the KV cache with context: 91.98% less foreground compilation time and 33.05% lower average KV memory, while preserving model quality and decoding. Cached sorted compiler dependency vectors to reduce CPU sorting time by 94.2%, and built CPU/GPU/NPU benchmarks to guide device placement.",
    "highlighted": true
  },
  {
    "id": "os-inference",
    "title": "Operating Systems for AI Inference",
    "authors": "<strong>Xuming Huang</strong> · advised by Prof. <a href=\"https://pages.cs.wisc.edu/~swift/\">Michael Swift</a>",
    "venue": "Honors Course Research Project · UW–Madison · Jan.–May 2026",
    "year": 2026,
    "image": "images/papers/os-inference-latency.png",
    "paper_url": "https://docs.google.com/document/d/15pNuKDQgvkAWLeXrKSWEwKa0xczQuOOfzaygKZMf61A/edit?usp=sharing",
    "paper_label": "project report",
    "selected": true,
    "category": "completed",
    "abstract": "Measured how background filesystem reads interfere with a fixed LLM inference workload: median latency increased 17.1%. Windows PerfMon showed stable working sets and page-fault counts plateauing near 29.5K, supporting shared-resource contention as the explanation rather than working-set thrashing.",
    "highlighted": false
  },
  {
    "id": "linuxguard-2025",
    "title": "LinuxGuard: AI for System Security",
    "authors": "<strong>Xuming Huang</strong> · advised by Prof. Remzi Arpaci-Dusseau and Dr. <a href=\"https://www.vinaybanakar.com/\">Vinay Banakar</a> · <a href=\"https://research.cs.wisc.edu/adsl/\">The ADvanced Systems Laboratory (ADSL)</a>",
    "venue": "Undergraduate Researcher · UW–Madison · Jan.–Nov. 2025",
    "year": 2025,
    "image": "images/papers/linuxguard_paradigm.jpg",
    "paper_url": "linuxguard.html",
    "paper_label": "project",
    "project_url": "blog/posts/linuxguard-journey.html",
    "project_label": "retrospective",
    "code_url": "https://github.com/Mac-Huang/LinuxGuard",
    "selected": true,
    "category": "completed",
    "abstract": "Built an LLM-driven pipeline over 50K+ Linux kernel commits to generate Clang-Tidy analyzers. Clustering and compiler-feedback repair produced 4× more valid checkers at 73% precision. A full-kernel validation harness uncovered 43 long-latent bugs with an average age of 4.7 years.",
    "highlighted": true
  },
  {
    "id": "cash",
    "title": "ML-Guided Scheduling for Heterogeneous Compute Systems",
    "authors": "<strong>Xuming Huang</strong> · coauthor; advised by Prof. Xing Hu",
    "venue": "Undergraduate Researcher · USST · Jan. 2024–Sept. 2026",
    "year": 2026,
    "image": "images/papers/cash-figure.png",
    "paper_url": "https://www.techscience.com/cmc/v89n2/68821",
    "paper_label": "paper",
    "selected": true,
    "category": "completed",
    "abstract": "Contributed to experimental validation and performance analysis of CASH, which predicts workload–hardware affinity for CPU/GPU placement. In 5,000-task simulations using MIT Supercloud traces, the scheduler achieved 97.1% resource-matching accuracy, 46.5% lower response time, and 36.8% lower modeled energy than Meta-RHDC.",
    "highlighted": false
  }
];

function getPublicationsByCategory(category) {
  if (category === 'all') return [...publications];
  if (category === 'selected') return publications.filter(p => p.selected);
  return publications.filter(p => p.category === category);
}
function getSelectedPublications() { return publications.filter(p => p.selected); }
function getPublicationsByYear(year) { return publications.filter(p => p.year === year); }
const publicationCategories = [
  {label:'All experience',value:'all'},
  {label:'Ongoing',value:'ongoing'},
  {label:'Completed',value:'completed'}
];
