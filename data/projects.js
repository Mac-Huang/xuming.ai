// Projects data - simple JavaScript array following publication structure
const projects = [
  // ⭐ HIGHLIGHTED PROJECTS
  {
    id: 'heap-allocator',
    title: '⭐ Heap Allocator Visualization',
    description: 'Interactive visualization of heap memory allocation strategies. Compare implicit and explicit free-list implementations, observe block splitting and coalescing, understand fragmentation patterns, and explore memory management algorithms.',
    tech: 'JavaScript, D3.js, Systems Programming, Memory Management',
    thumbnail: 'images/projects/heap-allocator-thumb.jpg',
    demo_url: 'demos/heap-allocator.html',
    code_url: null,
    featured: true,
    highlighted: true
  },

  {
    id: 'sorting-visualizer',
    title: '⭐ Sorting Algorithm Visualizer',
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

  {
    id: 'word2vec',
    title: '⭐ Word2Vec Implementation',
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
    title: '⭐ LSTM Tasks Suite',
    description: 'Collection of LSTM-based deep learning projects including sequence prediction, text generation, and time series forecasting. Demonstrates various applications of recurrent neural networks.',
    tech: 'TensorFlow/PyTorch, LSTM, RNNs, Sequence Modeling',
    thumbnail: 'images/projects/lstm-thumb.jpg',
    demo_url: null,
    code_url: 'https://github.com/Mac-Huang/LSTM_Tasks',
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
