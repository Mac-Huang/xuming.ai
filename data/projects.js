// Projects data - simple JavaScript array following publication structure
const projects = [
  // Machine Learning Projects
  {
    id: 'heap-allocator',
    title: 'Heap Allocator Visualization',
    description: 'Interactive visualization of heap memory allocation strategies. Compare implicit and explicit free-list implementations, observe block splitting and coalescing, understand fragmentation patterns, and explore memory management algorithms.',
    tech: 'JavaScript, D3.js, Systems Programming, Memory Management',
    thumbnail: 'images/projects/heap-allocator-thumb.jpg',
    demo_url: 'demos/heap-allocator.html',
    code_url: null,
    featured: true
  },

  {
    id: 'sorting-visualizer',
    title: 'Sorting Algorithm Visualizer',
    description: 'Interactive visualization of common sorting algorithms including quicksort, mergesort, heapsort, and more. Watch how different algorithms approach the sorting problem with visual feedback for comparisons and swaps.',
    tech: 'Vanilla JavaScript, HTML5 Canvas',
    thumbnail: 'images/projects/sorting-thumb.jpg',
    demo_url: 'demos/sorting.html',
    code_url: 'https://github.com/mac-huang/algorithms',
    featured: false
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
    title: 'Word2Vec Implementation',
    description: 'Implementation of Word2Vec models including Skip-gram and CBOW architectures for word embeddings. Includes training on custom corpora and visualization of learned embeddings.',
    tech: 'Python, NumPy, NLP, Word Embeddings',
    thumbnail: 'images/projects/word2vec-thumb.jpg',
    demo_url: null,
    code_url: 'https://github.com/Mac-Huang/Word2Vec',
    featured: true
  },
  
  {
    id: 'lstm-tasks',
    title: 'LSTM Tasks Suite',
    description: 'Collection of LSTM-based deep learning projects including sequence prediction, text generation, and time series forecasting. Demonstrates various applications of recurrent neural networks.',
    tech: 'TensorFlow/PyTorch, LSTM, RNNs, Sequence Modeling',
    thumbnail: 'images/projects/lstm-thumb.jpg',
    demo_url: null,
    code_url: 'https://github.com/Mac-Huang/LSTM_Tasks',
    featured: true
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
