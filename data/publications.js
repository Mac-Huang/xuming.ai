// Publications data - actual research experience and ongoing work
const publications = [
  // Current Research Projects (2025)
  {
    id: 'linuxguard-2025',
    title: 'LinuxGuard: Automated Static Analyzer Generation from Kernel Bug Fixes',
    authors: '<strong>Xuming Huang</strong> (advised by Remzi Arpaci-Dusseau, Vinay Banakar)',
    venue: 'Ongoing Research Project',
    year: 2025,
    image: 'images/papers/linuxguard_paradigm.jpg',
    paper_url: 'linuxguard.html',
    code_url: "https://github.com/Mac-Huang/LinuxGuard.git",
    project_url: null,
    bibtex: null,
    selected: true,
    category: 'ongoing',
    abstract: 'Developing an LLM-powered system that automatically converts Linux kernel bug fixes into clang-tidy static analyzers. By learning from historical commit patterns, LinuxGuard generates checkers that detect similar vulnerabilities across different kernel versions, effectively transforming every patched bug into a preventive tool. The system leverages RAG-enhanced architectures and program analysis techniques to achieve high-precision vulnerability detection while reducing manual effort in kernel security maintenance.'
  },


  {
    id: 'cifar10-classification-2024',
    title: 'Image Classification Algorithm Analysis: A Comparative Study of Traditional ML and Deep Learning Approaches',
    authors: '<strong>Xuming Huang</strong> (supervised by Prof. Dunlu Peng)',
    venue: 'Shanghai Research Project',
    year: 2024,
    image: 'images/papers/ResMacNet.jpg',
    paper_url: null,
    code_url: 'https://github.com/Mac-Huang/CIFAR10-Image-Classification',
    project_url: null,
    bibtex: null,
    selected: false,
    category: 'research',
    abstract: 'Comprehensive analysis comparing traditional ML methods with CNN architectures on CIFAR-10 dataset. Implemented custom architectures achieving 81.3% accuracy. Developed 2-stage inference using ResMacNet, achieving 13% improvement over baseline.'
  },

  {
    id: 'multispectral-unet-2024',
    title: 'Multispectral U-Net Segmentation Research',
    authors: '<strong>Xuming Huang</strong>, Prof. Xin Hu',
    venue: 'Research Project',
    year: 2024,
    image: 'images/papers/unet.jpg',
    paper_url: 'https://arxiv.org/abs/2506.05972',
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
