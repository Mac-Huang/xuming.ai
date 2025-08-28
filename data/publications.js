// Publications data - actual research experience and ongoing work
const publications = [
  // Current Research Projects (2025)
  {
    id: 'linuxguard-2025',
    title: 'LinuxGuard: AI-Powered Kernel Security Analysis',
    authors: '<strong>Xuming Huang</strong>, Remzi Arpaci-Dusseau, Vinay Banakar',
    venue: 'Ongoing Research Project',
    year: 2025,
    image: 'images/papers/linuxguard.jpg',
    paper_url: null,
    code_url: null,
    project_url: null,
    bibtex: null,
    selected: true,
    category: 'ongoing',
    abstract: 'Building AI pipeline processing Linux commits to generate static analyzers. Developed RAG-enhanced LLM system achieving 72% precision in kernel vulnerability detection. Applied ML clustering (K-means, TF-IDF) to derive high-confidence vulnerability anti-patterns.'
  },
  
  {
    id: 'heterogeneous-scheduler-2025',
    title: 'Heterogeneous Task Scheduler for CPU-GPU Systems',
    authors: '<strong>Xuming Huang</strong>',
    venue: 'Independent Research Project',
    year: 2025,
    image: 'images/papers/scheduler.jpg',
    paper_url: null,
    code_url: null,
    project_url: null,
    bibtex: null,
    selected: true,
    category: 'ongoing',
    abstract: 'Building C runtime system auto-scheduling computational tasks between CPU/GPU. Implementing CUDA kernels with cuBLAS optimization and memory pooling for efficient heterogeneous computing.'
  },
  
  {
    id: 'multispectral-unet-2024',
    title: 'Multispectral U-Net Segmentation Research',
    authors: '<strong>Xuming Huang</strong>, Prof. Xin [Last Name]',
    venue: 'Research Project',
    year: 2024,
    image: 'images/papers/unet.jpg',
    paper_url: null,
    code_url: null,
    project_url: null,
    bibtex: null,
    selected: false,
    category: 'ongoing',
    abstract: 'Developing advanced U-Net architectures for multispectral image segmentation with applications in remote sensing and medical imaging.'
  }
];

// Helper functions
function getPublicationsByCategory(category) {
  if (category === 'all') return publications;
  if (category === 'selected') return publications.filter(pub => pub.selected === true);
  return publications.filter(pub => pub.category === category);
}

function getSelectedPublications() {
  return publications.filter(pub => pub.selected === true);
}

function getPublicationsByYear(year) {
  return publications.filter(pub => pub.year === year);
}

// Publication categories for filtering
const publicationCategories = [
  { label: 'All', value: 'all' },
  { label: 'Selected', value: 'selected' },
  { label: 'Ongoing Research', value: 'ongoing' },
  { label: 'Conference', value: 'conference' },
  { label: 'Journal', value: 'journal' },
  { label: 'Preprint', value: 'preprint' }
];