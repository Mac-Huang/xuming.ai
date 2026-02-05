// Projects data - simple JavaScript array following publication structure
const projects = [
  // Machine Learning & Systems Projects
  {
    id: 'memory-architecture',
    title: 'Interactive Memory Architecture',
    description: 'Zoomable, bottom-up visualization of computer memory systems. Start from basic Logic Gates to build D-Latches and Flip-Flops, combine them into Registers, and finally construct a functional RAM block. Features interactive bit toggling and manual clock control to understand data flow and storage mechanisms.',
    tech: 'Vanilla JavaScript, HTML5 Canvas, Digital Logic',
    thumbnail: 'images/projects/memory-thumb.jpg', // Placeholder, system will use default if missing
    demo_url: 'demos/memory-architecture.html',
    code_url: null,
    featured: true,
    highlighted: true
  },

  {
    id: 'kmap-visualizer',
    title: 'K-Map Visualizer - 2D & 3D Interactive',
    description: 'Advanced Karnaugh Map visualizer with automatic grouping and Boolean expression simplification. Features both traditional 2D K-maps and innovative 3D cube representation for 3+ variables. Interactive 3D visualization allows rotation, zooming, and cell toggling. Supports up to 6 variables with truth tables, minterms, and expression input methods.',
    tech: 'JavaScript, Three.js, Digital Logic, Boolean Algebra',
    thumbnail: 'images/projects/kmap_thumb.jpg',
    demo_url: 'demos/kmap-visualizer-fixed.html',
    code_url: null,
    featured: true,
    highlighted: true
  },

  {
    id: 'x86-64-memory',
    title: 'x86-64 Memory Layout Visualizer - Enhanced',
    description: 'Interactive visualization of process memory layout on x86-64 architecture. Write C code and watch how text, data, heap, and stack segments are allocated in real-time. Features step-by-step execution, register tracking (RIP/RSP), dynamic memory visualization, and multiple example programs.',
    tech: 'JavaScript, D3.js, Systems Programming, x86-64 Architecture',
    thumbnail: 'images/projects/x86-memory-layout-thumb.jpg',
    demo_url: 'demos/x86-64-memory-enhanced.html',
    code_url: null,
    featured: true,
    highlighted: true
  },

  {
    id: 'heap-allocator',
    title: 'Heap Allocator Visualization',
    description: 'Interactive visualization of heap memory allocation strategies. Compare implicit and explicit free-list implementations, observe block splitting and coalescing, understand fragmentation patterns, and explore memory management algorithms.',
    tech: 'JavaScript, D3.js, Systems Programming, Memory Management',
    thumbnail: 'images/projects/heap-allocator-thumb.jpg',
    demo_url: 'demos/heap-allocator.html',
    code_url: null,
    featured: true,
    highlighted: true
  },

  {
    id: 'git-visualizer',
    title: 'Git Visualizer - Interactive Git Learning Tool',
    description: 'Learn Git commands interactively through visualization. Type real git commands and watch how they affect the repository structure in real-time. Features tutorial mode with step-by-step scenarios, sandbox mode for free exploration, and support for all major git operations including commit, branch, merge, rebase, cherry-pick, and more. Perfect for understanding version control concepts visually.',
    tech: 'JavaScript, SVG, Git Concepts, Interactive Learning',
    thumbnail: 'images/projects/git-visualizer-thumb.jpg',
    demo_url: 'demos/git-visualizer.html',
    code_url: 'https://github.com/xuming-huang/git-visualizer',
    featured: true,
    highlighted: false
  },

  {
    id: 'tenant-sos',
    title: 'TenantSOS - Legal Information iOS App',
    description: 'iOS application providing location-based legal information for tenants across U.S. states. Features automatic GPS-based state law detection, comprehensive legal database covering tenant rights, traffic laws, employment regulations, and consumer protections. Includes 10+ legal document templates, smart notifications for law changes, and offline law access. Built with Swift 5.9 and SwiftUI, powered by Firebase backend with Core Location for state detection. Implements freemium model with basic free tier and pro subscription for unlimited features across all 50 states.',
    tech: 'Swift 5.9, SwiftUI, Firebase, Core Location, Core Data, CloudKit',
    thumbnail: 'images/projects/tenant-sos-thumb.jpg',
    demo_url: null,
    code_url: 'https://github.com/Mac-Huang/Tenant-SOS',
    featured: true,
    highlighted: false
  },

  {
    id: 'graph-algorithms',
    title: 'Graph Algorithms Playground',
    description: 'Visualize graph traversal algorithms including BFS, DFS, Dijkstra\'s shortest path, and A* pathfinding. Create custom graphs and watch algorithms explore them step by step.',
    tech: 'JavaScript, D3.js, SVG',
    thumbnail: 'images/projects/graph-thumb.jpg',
    demo_url: 'demos/graphs.html',
    code_url: 'https://github.com/mac-huang/algorithms',
    featured: false
  },

  {
    id: 'sorting-visualizer',
    title: 'Sorting Algorithm Visualizer',
    description: 'Interactive visualization of common sorting algorithms including quicksort, mergesort, heapsort, and more. Watch how different algorithms approach the sorting problem with visual feedback for comparisons and swaps.',
    tech: 'Vanilla JavaScript, HTML5 Canvas',
    thumbnail: 'images/projects/sorting-thumb.jpg',
    demo_url: 'demos/sorting.html',
    code_url: 'https://github.com/mac-huang/algorithms',
    featured: true,
    highlighted: true
  },

  // Interactive Demos (Original)

  {
    id: 'hash-collision-analysis',
    title: 'Hash Function & Collision Analysis',
    description: 'Interactive visualization of hash functions, collision resolution strategies, and advanced applications like Bloom filters and consistent hashing. Explore distribution patterns, analyze collision rates, and understand how different hash functions perform.',
    tech: 'JavaScript, D3.js, Canvas, Algorithms',
    thumbnail: 'images/projects/hashing-thumb.jpg',
    demo_url: 'demos/hashing.html',
    code_url: null,
    featured: true
  },

  {
    id: 'tensor-operations',
    title: 'Interactive Tensor Operations Visualizer',
    description: 'Understand fundamental tensor operations in neural networks through interactive visualizations. Features matrix multiplication animation, 2D convolution demonstrations, tensor reshaping, broadcasting rules, and backpropagation visualization. Perfect for learning deep learning mathematics.',
    tech: 'JavaScript, D3.js, Deep Learning, Linear Algebra',
    thumbnail: 'images/projects/tensor-ops-thumb.jpg',
    demo_url: 'demos/tensor-ops.html',
    code_url: null,
    featured: true
  },

  {
    id: 'neural-network',
    title: 'Neural Network Playground',
    description: 'Train simple neural networks in your browser. Experiment with network architecture, activation functions, and learning rates while visualizing decision boundaries in real-time.',
    tech: 'JavaScript, TensorFlow.js, Canvas',
    thumbnail: 'images/projects/neural-thumb.jpg',
    demo_url: 'demos/neural.html',
    code_url: null,
    featured: false
  },

  // Deep Learning Architecture Tutorials
  {
    id: 'understanding-transformers',
    title: 'Understanding Transformers',
    description: 'Comprehensive tutorial on Transformer architecture with implementations. Covers self-attention, positional encoding, multi-head attention, and complete implementation walkthrough with visualizations.',
    tech: 'Python, PyTorch, NumPy, Visualization',
    thumbnail: 'images/projects/transformer-tutorial-thumb.jpg',
    demo_url: null,
    code_url: 'https://github.com/Mac-Huang/Transformer',
    featured: true,
    highlighted: true
  },

  {
    id: 'transformer-architecture',
    title: 'Interactive Transformer Architecture Visualization',
    description: 'Deep dive into transformer models with step-by-step visualization of attention mechanisms, positional encoding, and layer operations. Supports encoder-only (BERT), decoder-only (GPT), and encoder-decoder architectures.',
    tech: 'JavaScript, D3.js, TensorFlow.js, Deep Learning',
    thumbnail: 'images/projects/transformer-thumb.jpg',
    demo_url: 'demos/transformer-architecture.html',
    code_url: null,
    featured: true
  },

  {
    id: 'gpt-implementation',
    title: 'GPT Implementation Guide',
    description: 'Step-by-step implementation and explanation of GPT models. From tokenization to training loop, understand how autoregressive language models work with practical code examples.',
    tech: 'Python, PyTorch, Transformers, NLP',
    thumbnail: 'images/projects/gpt-guide-thumb.jpg',
    demo_url: null,
    code_url: 'https://github.com/Mac-Huang/GPT',
    featured: true,
    highlighted: true
  },

  {
    id: 'neural-translator',
    title: 'Neural Machine Translator',
    description: 'Sequence-to-sequence neural machine translation system implementing attention mechanisms. Supports multiple language pairs with encoder-decoder architecture and beam search decoding.',
    tech: 'PyTorch, Transformers, NMT, Attention',
    thumbnail: 'images/projects/translator-thumb.jpg',
    demo_url: null,
    code_url: 'https://github.com/Mac-Huang/Translator',
    featured: true
  },

  // Advanced Systems Visualizations
  {
    id: 'bplus-tree',
    title: 'B+ Tree Database Index Simulator',
    description: 'Interactive visualization of B+ tree operations showing how database indexes work internally. Features insertion with node splitting, deletion with merging, range queries, and performance metrics comparison with binary search trees.',
    tech: 'JavaScript, D3.js, Database Systems, Data Structures',
    thumbnail: 'images/projects/bplus-tree-thumb.jpg',
    demo_url: 'demos/bplus-tree.html',
    code_url: null,
    featured: true
  },

  {
    id: 'tree-visualizer',
    title: 'BST & Red-Black Tree Visualizer',
    description: 'Interactive visualization of Binary Search Tree and Red-Black Tree operations. Features animated insertion, deletion, search, and rotation operations. Visualize self-balancing behavior, color changes in Red-Black trees, and compare performance between BST and Red-Black implementations. Perfect for learning tree data structures.',
    tech: 'JavaScript, D3.js, Data Structures, Algorithms',
    thumbnail: 'images/projects/redblack-tree-thumb.jpg',
    demo_url: 'demos/bst-tree.html',
    code_url: null,
    featured: true,
    highlighted: true
  },

  {
    id: 'garbage-collection',
    title: 'Garbage Collection Algorithm Visualizer',
    description: 'Comprehensive visualization of memory management and GC algorithms including Mark & Sweep, Reference Counting, Generational GC, and Copying Collector. Shows heap regions, reference graphs, and real-time performance metrics.',
    tech: 'JavaScript, D3.js, Memory Management, JVM',
    thumbnail: 'images/projects/gc-thumb.jpg',
    demo_url: 'demos/garbage-collection.html',
    code_url: null,
    featured: true
  },

  {
    id: 'compiler-pipeline',
    title: 'Interactive Compiler Pipeline Visualization',
    description: 'Step-by-step visualization of compilation phases from source code to assembly. Includes lexical analysis, parsing, AST generation, semantic analysis, IR generation, optimization passes, and code generation with register allocation.',
    tech: 'JavaScript, CodeMirror, D3.js, Compilers',
    thumbnail: 'images/projects/compiler-thumb.jpg',
    demo_url: 'demos/compiler-pipeline.html',
    code_url: null,
    featured: true
  },

  // Advanced Systems & Networking
  {
    id: 'consensus-algorithms',
    title: 'Distributed Systems Consensus Visualizer',
    description: 'Interactive visualization of consensus algorithms including Raft, Paxos, PBFT, and Gossip protocols. Simulate network partitions, node failures, leader elections, and Byzantine faults in distributed systems.',
    tech: 'JavaScript, D3.js, Distributed Systems, Consensus',
    thumbnail: 'images/projects/consensus-thumb.jpg',
    demo_url: 'demos/consensus-algorithms.html',
    code_url: null,
    featured: true
  },

  {
    id: 'word2vec',
    title: 'Word2Vec Implementation',
    description: 'Implementation of Word2Vec models including Skip-gram and CBOW architectures for word embeddings. Includes training on custom corpora and visualization of learned embeddings.',
    tech: 'Python, NumPy, NLP, Word Embeddings',
    thumbnail: 'images/projects/word2vec-thumb.jpg',
    demo_url: null,
    code_url: 'https://github.com/Mac-Huang/Word2Vec',
    featured: true,
    highlighted: true
  },

  {
    id: 'lstm-tasks',
    title: 'LSTM Tasks Suite',
    description: 'Collection of LSTM-based deep learning projects including sequence prediction, text generation, and time series forecasting. Demonstrates various applications of recurrent neural networks.',
    tech: 'TensorFlow/PyTorch, LSTM, RNNs, Sequence Modeling',
    thumbnail: 'images/projects/lstm-thumb.jpg',
    demo_url: null,
    code_url: 'https://github.com/Mac-Huang/LSTM_Tasks',
    featured: true,
    highlighted: true
  },
  {
    id: 'cpu-cache-simulator',
    title: 'CPU Cache Hierarchy Simulator',
    description: 'Comprehensive CPU cache simulator with L1/L2/L3 cache levels, various replacement policies (LRU, FIFO, Random), write policies, and memory access pattern analysis. Visualize cache hits/misses and performance metrics.',
    tech: 'JavaScript, Computer Architecture, Cache Memory',
    thumbnail: 'images/projects/cache-thumb.jpg',
    demo_url: 'demos/cpu-cache-simulator.html',
    code_url: null,
    featured: true
  },


  {
    id: 'wasm-performance',
    title: 'WebAssembly Performance Analyzer',
    description: 'Compare JavaScript vs WebAssembly performance across computational tasks including matrix operations, prime generation, and image processing. Real-time benchmarking with detailed performance metrics.',
    tech: 'WebAssembly, JavaScript, Performance Analysis',
    thumbnail: 'images/projects/wasm-thumb.jpg',
    demo_url: 'demos/wasm-performance.html',
    code_url: null,
    featured: true
  },
];

// Helper functions
function getFeaturedProjects() {
  return projects.filter(project => project.featured === true);
}

function getProjectsByTech(tech) {
  return projects.filter(project =>
    project.tech.toLowerCase().includes(tech.toLowerCase())
  );
}

function getAllProjects() {
  return projects;
}
