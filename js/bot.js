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
    focus: "I'm particularly interested in making large-scale ML training and inference more efficient."
  },
  
  topics: {
    "gradient checkpointing": "Gradient checkpointing (also called activation checkpointing) is a technique that trades compute for memory. Instead of storing all intermediate activations during the forward pass, we recompute them during backpropagation. This reduces memory usage by roughly (L-1)/L where L is the number of layers, but increases computation by about 33%. It enables training models 2-3x larger on the same hardware.",
    
    "distributed training": "Distributed training involves splitting model training across multiple GPUs or machines. Key techniques include data parallelism (each GPU processes different batches), model parallelism (splitting the model across GPUs), and pipeline parallelism (different layers on different GPUs). The main challenges are communication overhead and synchronization.",
    
    "zero optimizer": "The Zero Redundancy Optimizer (ZeRO) partitions optimizer states, gradients, and parameters across data parallel processes. Stage 1 partitions optimizer states (8x memory reduction for Adam), Stage 2 partitions gradients (2x additional), and Stage 3 partitions parameters (Nx reduction where N = number of GPUs).",
    
    "mixed precision": "Mixed precision training uses FP16 (half precision) for most operations while maintaining FP32 master weights for numerical stability. This reduces memory usage by nearly 50% for model weights and activations while maintaining model quality.",
    
    "flashattention": "FlashAttention is an IO-aware attention algorithm that reduces memory complexity from O(n²) to O(n) for sequence length n. It uses careful tiling to keep computations in fast SRAM rather than slower HBM memory, achieving 2-4x speedup.",
    
    "tensor parallelism": "Tensor parallelism splits individual layers across multiple GPUs. Each GPU holds a portion of the weight matrices, and activations are communicated between devices during forward and backward passes. Essential for models that don't fit on a single GPU.",
    
    "pipeline parallelism": "Pipeline parallelism splits a model's layers across different GPUs, with each GPU responsible for a subset of layers. It uses micro-batching to keep all GPUs busy and reduce bubble time.",
    
    "memory optimization": "Key techniques include gradient checkpointing (recompute activations), mixed precision training (FP16), optimizer state sharding (ZeRO), CPU offloading, and efficient attention mechanisms like FlashAttention."
  },
  
  courses: {
    stanford: ["CS107 Computer Organization & Systems (A+, 99/100)", "CS161 Design and Analysis of Algorithms (A, 93/100)"],
    uwmadison: ["Machine Learning Systems", "Operating Systems", "Distributed Systems", "Compiler Design", "Advanced Algorithms"]
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
  
  // Default response
  return "I can help you learn about my research in machine learning systems, publications, projects, and academic experience. Try asking about specific topics like gradient checkpointing, distributed training, my Stanford courses, or current projects. What would you like to know?";
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