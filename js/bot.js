// Xuming Bot - Minimal Academic Assistant
// Simple keyword-based bot with knowledge from publications, projects, and bio

// Knowledge Base
const knowledgeBase = {
  bio: {
    name: "Xuming Huang",
    role: "Junior Computer Science Student",
    university: "University of Wisconsin - Madison",
    interests: "Machine Learning Systems, Operating Systems, Efficient Computing Infrastructure",
    research: "MLSys, distributed systems, compiler optimization, and the intersection of systems and machine learning",
    stanford: "Last summer, I did my summer session at Stanford. I got A+ (99/100) in CS107 Computer Organization & Systems, and A (93/100) in CS161 Design and Analysis of Algorithms.",
    focus: "I'm particularly interested in making large-scale ML training and inference more efficient.",
    goals: "My career goal is to work on cutting-edge ML infrastructure at leading tech companies or pursue a PhD in ML systems.",
    skills: "Python, C++, Java, CUDA, PyTorch, JAX, distributed computing, compiler optimization, systems programming",
    experience: "I've interned at leading tech companies working on ML infrastructure, contributed to open-source projects, and published research papers in top conferences."
  },
  
  topics: {
    "gradient checkpointing": "Gradient checkpointing (also called activation checkpointing) is a technique that trades compute for memory. Instead of storing all intermediate activations during the forward pass, we recompute them during backpropagation. This reduces memory usage by roughly (L-1)/L where L is the number of layers, but increases computation by about 33%. It enables training models 2-3x larger on the same hardware.",
    
    "distributed training": "Distributed training involves splitting model training across multiple GPUs or machines. Key techniques include data parallelism (each GPU processes different batches), model parallelism (splitting the model across GPUs), and pipeline parallelism (different layers on different GPUs). The main challenges are communication overhead and synchronization.",
    
    "zero optimizer": "The Zero Redundancy Optimizer (ZeRO) partitions optimizer states, gradients, and parameters across data parallel processes. Stage 1 partitions optimizer states (8x memory reduction for Adam), Stage 2 partitions gradients (2x additional), and Stage 3 partitions parameters (Nx reduction where N = number of GPUs).",
    
    "mixed precision": "Mixed precision training uses FP16 (half precision) for most operations while maintaining FP32 master weights for numerical stability. This reduces memory usage by nearly 50% for model weights and activations while maintaining model quality.",
    
    "flashattention": "FlashAttention is an IO-aware attention algorithm that reduces memory complexity from O(n²) to O(n) for sequence length n. It uses careful tiling to keep computations in fast SRAM rather than slower HBM memory, achieving 2-4x speedup.",
    
    "tensor parallelism": "Tensor parallelism splits individual layers across multiple GPUs. Each GPU holds a portion of the weight matrices, and activations are communicated between devices during forward and backward passes. Essential for models that don't fit on a single GPU.",
    
    "pipeline parallelism": "Pipeline parallelism splits a model's layers across different GPUs, with each GPU responsible for a subset of layers. It uses micro-batching to keep all GPUs busy and reduce bubble time.",
    
    "memory optimization": "Key techniques include gradient checkpointing (recompute activations), mixed precision training (FP16), optimizer state sharding (ZeRO), CPU offloading, and efficient attention mechanisms like FlashAttention.",
    
    "quantization": "Quantization reduces model precision from FP32/FP16 to INT8 or even lower bits. This can reduce memory usage by 4x and accelerate inference significantly. Techniques include post-training quantization (PTQ) and quantization-aware training (QAT).",
    
    "model compression": "Model compression techniques include pruning (removing unnecessary weights), knowledge distillation (training smaller models to mimic larger ones), and neural architecture search (NAS) to find efficient architectures.",
    
    "cuda programming": "CUDA is NVIDIA's parallel computing platform. Key concepts include thread blocks, shared memory, warp divergence, and memory coalescing. Understanding CUDA is essential for optimizing GPU kernels in ML frameworks.",
    
    "compiler optimization": "ML compilers like XLA, TorchScript, and TVM optimize computation graphs. Key optimizations include operator fusion, memory planning, constant folding, and automatic kernel generation for specific hardware.",
    
    "attention mechanisms": "Attention is the core of transformers. Standard attention has O(n²) complexity. Efficient variants include linear attention, sparse attention, and techniques like FlashAttention that optimize memory access patterns.",
    
    "distributed communication": "Key communication primitives in distributed training include AllReduce (for gradient aggregation), AllGather, ReduceScatter, and point-to-point communication. Libraries like NCCL optimize these for GPU clusters.",
    
    "automatic differentiation": "AutoDiff is how ML frameworks compute gradients. There are two modes: forward-mode (computing Jacobian-vector products) and reverse-mode (vector-Jacobian products). Reverse-mode is used for backpropagation.",
    
    "hardware acceleration": "Modern ML uses specialized hardware: GPUs for parallel computation, TPUs for matrix operations, and emerging technologies like neuromorphic chips. Understanding hardware architecture is crucial for optimization."
  },
  
  courses: {
    stanford: ["CS107 Computer Organization & Systems (A+, 99/100)", "CS161 Design and Analysis of Algorithms (A, 93/100)"],
    uwmadison: ["COMP SCI 200 Programming I", "ECE 252 Computer Engineering", "MATH 340 Linear Algebra", "COMP SCI 240 Discrete Mathematics"],
    future: ["COMP SCI 352 Digital System Fundamentals", "COMP SCI 552 Computer Architecture", "COMP SCI 537 Operating Systems", "COMP SCI 744 Big Data Systems"]
  },
  
  hobbies: {
    sports: "I'm passionate about football and was part of the NFL FLAG Football Championship team.",
    interests: "Besides coding, I enjoy reading about technology trends, contributing to open source, and mentoring other students.",
    activities: "I participate in hackathons, tech talks, and research seminars at UW-Madison."
  },
  
  advice: {
    learning: "Start with strong fundamentals - understand how computers work at a low level before jumping into high-level abstractions. Build projects that solve real problems.",
    career: "Focus on depth rather than breadth. Master one area deeply while maintaining broad knowledge. Contribute to open source and engage with the research community.",
    research: "Read papers critically, replicate results, and always question assumptions. The best research comes from identifying real problems in existing systems."
  }
};

// Response generation
function generateResponse(message) {
  const lower = message.toLowerCase();
  
  // Bio and introduction
  if (lower.includes('who are you') || lower.includes('introduce') || lower.includes('about you')) {
    return `I'm ${knowledgeBase.bio.name}, a ${knowledgeBase.bio.role} at ${knowledgeBase.bio.university}. My research interests include ${knowledgeBase.bio.research}. ${knowledgeBase.bio.focus}`;
  }
  
  // Current research
  if (lower.includes('research') && (lower.includes('current') || lower.includes('focus') || lower.includes('interest'))) {
    return `My current research focuses on ${knowledgeBase.bio.interests}. ${knowledgeBase.bio.focus} I work on optimizing large-scale ML systems through techniques like gradient checkpointing, distributed training, and compiler optimizations.`;
  }
  
  // Stanford experience
  if (lower.includes('stanford')) {
    return knowledgeBase.bio.stanford + " This experience strengthened my foundation in systems programming and algorithm design, which directly applies to my current work in ML systems optimization.";
  }
  
  // Courses
  if (lower.includes('course') || lower.includes('class')) {
    if (lower.includes('stanford')) {
      return "At Stanford, I took: " + knowledgeBase.courses.stanford.join(", ") + ". These courses provided excellent foundations in systems and algorithms.";
    }
    if (lower.includes('wisconsin') || lower.includes('madison') || lower.includes('uw')) {
      return "At UW-Madison, I'm focusing on: " + knowledgeBase.courses.uwmadison.join(", ") + ". These courses align with my research interests in ML systems.";
    }
    return "I've taken courses at both Stanford (" + knowledgeBase.courses.stanford.join(", ") + ") and UW-Madison focusing on " + knowledgeBase.courses.uwmadison.slice(0, 3).join(", ") + " and more.";
  }
  
  // Publications
  if (lower.includes('publication') || lower.includes('paper') || lower.includes('research paper')) {
    if (typeof publications !== 'undefined') {
      const selected = publications.filter(p => p.selected).slice(0, 3);
      let response = "Here are some of my key publications:\n\n";
      selected.forEach(pub => {
        response += `• "${pub.title}" (${pub.venue}, ${pub.year})\n`;
      });
      response += "\nYou can find the complete list on my Research page.";
      return response;
    }
    return "I have several publications in machine learning systems, including work on efficient LLM training, distributed systems, and compiler optimizations. Check the Research page for the full list.";
  }
  
  // Projects
  if (lower.includes('project')) {
    if (typeof projects !== 'undefined') {
      const featured = projects.filter(p => p.featured).slice(0, 3);
      let response = "I've created several educational and research projects:\n\n";
      featured.forEach(proj => {
        response += `• ${proj.title}: ${proj.description.split('.')[0]}.\n`;
      });
      response += "\nVisit the Projects page to see live demos and more projects.";
      return response;
    }
    return "I work on various projects including algorithm visualizers, ML tools, and system optimizations. Check the Projects page for interactive demos.";
  }
  
  // Technical topics
  for (const [topic, explanation] of Object.entries(knowledgeBase.topics)) {
    if (lower.includes(topic) || lower.includes(topic.replace(' ', ''))) {
      return explanation;
    }
  }
  
  // Specific technical questions
  if (lower.includes('memory') && (lower.includes('optimization') || lower.includes('reduce'))) {
    return knowledgeBase.topics["memory optimization"];
  }
  
  if (lower.includes('parallel') && lower.includes('train')) {
    return "There are three main types of parallelism in ML training: " + knowledgeBase.topics["distributed training"];
  }
  
  // Collaboration
  if (lower.includes('collaborat') || lower.includes('contribut') || lower.includes('work with') || lower.includes('help')) {
    return "I'm always interested in collaborating on ML systems research! You can contribute to my open-source projects on GitHub (github.com/mac-huang), or reach out via email to discuss research opportunities. I'm particularly interested in memory optimization, distributed training, and compiler optimizations for ML.";
  }
  
  // Blog
  if (lower.includes('blog') || lower.includes('writing')) {
    return "I write technical blog posts about machine learning systems, performance engineering, and research insights. Recent topics include memory optimization for LLM training, common pitfalls in distributed training, and compiler optimizations. Check the Blog section for more.";
  }
  
  // Contact
  if (lower.includes('contact') || lower.includes('email') || lower.includes('reach')) {
    return "The best way to reach me is via email (click 'show email' on the homepage). I'm also on GitHub (mac-huang) and LinkedIn. Feel free to reach out about research collaborations, technical discussions, or questions about my work!";
  }
  
  // Career and goals
  if (lower.includes('goal') || lower.includes('career') || lower.includes('future')) {
    return knowledgeBase.bio.goals + " I'm actively seeking internship opportunities in ML infrastructure and systems optimization.";
  }
  
  // Skills and programming
  if (lower.includes('skill') || lower.includes('programming') || lower.includes('language')) {
    return "My technical skills include: " + knowledgeBase.bio.skills + ". I have extensive experience with ML frameworks, distributed systems, and low-level systems programming.";
  }
  
  // Experience
  if (lower.includes('experience') || lower.includes('internship')) {
    return knowledgeBase.bio.experience + " These experiences have given me deep insights into production ML systems and research methodologies.";
  }
  
  // Hobbies and interests
  if (lower.includes('hobby') || lower.includes('hobbies') || lower.includes('fun') || lower.includes('free time')) {
    return knowledgeBase.hobbies.sports + " " + knowledgeBase.hobbies.interests + " " + knowledgeBase.hobbies.activities;
  }
  
  // Sports
  if (lower.includes('sport') || lower.includes('football') || lower.includes('nfl')) {
    return knowledgeBase.hobbies.sports + " It was an amazing experience that taught me about teamwork, perseverance, and performing under pressure - skills that translate well to collaborative research and engineering projects.";
  }
  
  // Advice
  if (lower.includes('advice') || lower.includes('tip') || lower.includes('recommend')) {
    if (lower.includes('learn')) {
      return "My advice for learning: " + knowledgeBase.advice.learning;
    }
    if (lower.includes('career')) {
      return "Career advice: " + knowledgeBase.advice.career;
    }
    if (lower.includes('research')) {
      return "Research advice: " + knowledgeBase.advice.research;
    }
    return "Here's my advice: " + knowledgeBase.advice.learning + " Also, " + knowledgeBase.advice.career;
  }
  
  // Technical questions about new topics
  if (lower.includes('quantization')) {
    return knowledgeBase.topics["quantization"];
  }
  
  if (lower.includes('compression') && lower.includes('model')) {
    return knowledgeBase.topics["model compression"];
  }
  
  if (lower.includes('cuda')) {
    return knowledgeBase.topics["cuda programming"];
  }
  
  if (lower.includes('compiler') && (lower.includes('ml') || lower.includes('optimization'))) {
    return knowledgeBase.topics["compiler optimization"];
  }
  
  if (lower.includes('attention') && !lower.includes('flash')) {
    return knowledgeBase.topics["attention mechanisms"];
  }
  
  if (lower.includes('communication') && lower.includes('distributed')) {
    return knowledgeBase.topics["distributed communication"];
  }
  
  if (lower.includes('autodiff') || lower.includes('automatic differentiation') || lower.includes('backprop')) {
    return knowledgeBase.topics["automatic differentiation"];
  }
  
  if (lower.includes('hardware') || lower.includes('accelerat') || lower.includes('tpu') || lower.includes('gpu')) {
    return knowledgeBase.topics["hardware acceleration"];
  }
  
  // Future courses
  if (lower.includes('next semester') || lower.includes('future') && lower.includes('course')) {
    return "I'm planning to take: " + knowledgeBase.courses.future.join(", ") + ". These courses will deepen my understanding of systems and architecture.";
  }
  
  // Why ML Systems
  if (lower.includes('why') && (lower.includes('mlsys') || lower.includes('ml systems') || lower.includes('machine learning systems'))) {
    return "I'm passionate about ML systems because they sit at the intersection of cutting-edge AI and hardcore systems engineering. As models grow larger, the systems challenges become more critical - we need to innovate at every layer of the stack from hardware to compilers to distributed systems. This field directly impacts what's possible in AI.";
  }
  
  // Research interests deep dive
  if (lower.includes('tell me more') && lower.includes('research')) {
    return "My research explores how to make ML training and inference more efficient. This includes: 1) Memory optimization techniques to train larger models, 2) Compiler optimizations for better hardware utilization, 3) Novel parallelization strategies for distributed training, 4) Hardware-aware algorithm design. I believe the next breakthroughs in AI will come from systems innovations.";
  }
  
  // Default response
  return "I can help you learn about my research in machine learning systems, publications, projects, and academic experience. Try asking about specific topics like gradient checkpointing, distributed training, my Stanford courses, career goals, or advice for students. What would you like to know?";
}

// Chat functionality
function sendMessage() {
  const input = document.getElementById('message-input');
  const message = input.value.trim();
  
  if (!message) return;
  
  // Add user message
  addMessage(message, 'user');
  
  // Clear input
  input.value = '';
  
  // Generate and add bot response
  setTimeout(() => {
    const response = generateResponse(message);
    addMessage(response, 'bot');
  }, 300);
}

function addMessage(text, sender) {
  const messagesDiv = document.getElementById('messages');
  const messageDiv = document.createElement('div');
  messageDiv.className = sender + '-message';
  messageDiv.style.margin = '10px 0';
  messageDiv.style.padding = '8px';
  
  if (sender === 'user') {
    messageDiv.style.textAlign = 'right';
    messageDiv.innerHTML = '<span style="color:#1772d0;"><strong>You:</strong> ' + text + '</span>';
  } else {
    messageDiv.style.textAlign = 'left';
    // Convert line breaks to <br> for multi-line responses
    const formattedText = text.replace(/\n/g, '<br>');
    messageDiv.innerHTML = '<strong>Xuming Bot:</strong> ' + formattedText;
  }
  
  messagesDiv.appendChild(messageDiv);
  
  // Scroll to bottom
  const container = document.getElementById('chat-container');
  container.scrollTop = container.scrollHeight;
}

function askQuestion(question) {
  document.getElementById('message-input').value = question;
  sendMessage();
}