// Projects data - simple JavaScript array following publication structure
const projects = [
  // Machine Learning Projects
  {
    id: 'cifar10-classification',
    title: 'CIFAR-10 Image Classification',
    description: 'Deep learning project implementing various CNN architectures for CIFAR-10 image classification. Explores different models including ResNet, VGG, and custom architectures with data augmentation and optimization techniques.',
    tech: 'PyTorch, Python, CNNs, Computer Vision',
    thumbnail: 'images/projects/cifar10-thumb.jpg',
    demo_url: null,
    code_url: 'https://github.com/Mac-Huang/CIFAR10-Image-Classification',
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
  
  // MLSys Interactive Demos
  {
    id: 'neural-training-viz',
    title: 'Neural Network Training Visualizer',
    description: 'Interactive visualization of neural network training on 2D datasets. Experiment with different architectures, activation functions, and hyperparameters while watching the decision boundary evolve in real-time.',
    tech: 'TensorFlow.js, D3.js, JavaScript',
    thumbnail: 'images/projects/neural-training-thumb.jpg',
    demo_url: 'demos/neural-training.html',
    code_url: null,
    featured: true
  },
  
  {
    id: 'distributed-training',
    title: 'Distributed Training Simulator',
    description: 'Visualize distributed training strategies including data parallelism, model parallelism, and parameter server architectures. Observe communication patterns, synchronization overhead, and scaling efficiency.',
    tech: 'D3.js, JavaScript, Systems Visualization',
    thumbnail: 'images/projects/distributed-thumb.jpg',
    demo_url: 'demos/distributed-training.html',
    code_url: null,
    featured: true
  },
  
  {
    id: 'model-compression',
    title: 'Model Compression Playground',
    description: 'Explore model compression techniques including quantization, pruning, and knowledge distillation. Compare model size, accuracy, and inference speed trade-offs with interactive visualizations.',
    tech: 'JavaScript, D3.js, ML Optimization',
    thumbnail: 'images/projects/compression-thumb.jpg',
    demo_url: 'demos/model-compression.html',
    code_url: null,
    featured: true
  },
  
  {
    id: 'memory-management',
    title: 'Memory Management Visualizer',
    description: 'Understand how ML frameworks manage GPU memory. Visualize tensor allocation strategies, memory fragmentation, garbage collection, and optimization techniques for efficient memory usage.',
    tech: 'JavaScript, D3.js, Systems Programming',
    thumbnail: 'images/projects/memory-thumb.jpg',
    demo_url: 'demos/memory-management.html',
    code_url: null,
    featured: false
  },
  
  {
    id: 'pipeline-parallel',
    title: 'Pipeline Parallelism Demo',
    description: 'Visualize pipeline parallelism strategies for large model training. Compare naive, 1F1B (one forward one backward), and interleaved scheduling with bubble analysis and efficiency metrics.',
    tech: 'D3.js, JavaScript, Distributed Systems',
    thumbnail: 'images/projects/pipeline-thumb.jpg',
    demo_url: 'demos/pipeline-parallel.html',
    code_url: null,
    featured: false
  },
  
  // Interactive Demos (Original)
  {
    id: 'sorting-visualizer',
    title: 'Sorting Algorithm Visualizer',
    description: 'Interactive visualization of common sorting algorithms including quicksort, mergesort, heapsort, and more. Watch how different algorithms approach the sorting problem with visual feedback for comparisons and swaps.',
    tech: 'Vanilla JavaScript, HTML5 Canvas',
    thumbnail: 'images/projects/sorting-thumb.jpg',
    demo_url: 'demos/sorting.html',
    code_url: 'https://github.com/mac-huang/sorting-visualizer',
    featured: false
  },
  
  {
    id: 'graph-algorithms',
    title: 'Graph Algorithms Playground',
    description: 'Visualize graph traversal algorithms including BFS, DFS, Dijkstra\'s shortest path, and A* pathfinding. Create custom graphs and watch algorithms explore them step by step.',
    tech: 'JavaScript, D3.js, SVG',
    thumbnail: 'images/projects/graph-thumb.jpg',
    demo_url: 'demos/graphs.html',
    code_url: 'https://github.com/mac-huang/graph-algorithms',
    featured: false
  },
  
  {
    id: 'neural-network',
    title: 'Neural Network Playground',
    description: 'Train simple neural networks in your browser. Experiment with network architecture, activation functions, and learning rates while visualizing decision boundaries in real-time.',
    tech: 'JavaScript, TensorFlow.js, Canvas',
    thumbnail: 'images/projects/neural-thumb.jpg',
    demo_url: 'demos/neural.html',
    code_url: 'https://github.com/mac-huang/nn-playground',
    featured: false
  }
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