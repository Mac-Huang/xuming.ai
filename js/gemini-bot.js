// Enhanced Xuming Bot with Gemini API Integration
// Combines local knowledge base with Gemini's capabilities for richer responses

const GEMINI_API_KEY = 'AIzaSyAllu6kCLJqR9s2EFemZ4wvcwRaoCv6dtA';
const GEMINI_API_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

// Enhanced Knowledge Base with structured context
const enhancedKnowledgeBase = {
  systemPrompt: `You are Xuming Bot, representing Xuming Huang - a junior Computer Science student at UW-Madison. 
You have deep knowledge about:
- Xuming's academic journey (Stanford CS107 A+, CS161 A, AFS vulnerability discovery)
- Research in ML Systems, distributed computing, and compiler optimization
- Interactive CS visualizations and educational projects
- NFL FLAG Football National Champion 2023
- Technical expertise in C/C++, Python, CUDA, PyTorch, systems programming

Respond in a friendly, knowledgeable manner. For technical questions, provide clear explanations with examples.
Keep responses concise but informative. If asked about collaboration or opportunities, be encouraging and provide contact guidance.`,

  personalContext: {
    currentRole: "Junior CS Student at University of Wisconsin-Madison",
    summerExperience: "Stanford Summer 2025 - CS107 (A+, 99/100), CS161 (A, 93/100)",
    achievements: [
      "Discovered critical vulnerabilities in Stanford's AFS system",
      "NFL FLAG Football National Champion 2023",
      "Created popular interactive CS visualizations",
      "Published research in ML systems optimization"
    ],
    researchFocus: "Machine Learning Systems, Distributed Training, Compiler Optimization, Memory Management",
    technicalSkills: {
      languages: ["C/C++", "Python", "Java", "x86 Assembly", "CUDA", "JavaScript"],
      frameworks: ["PyTorch", "TensorFlow", "JAX", "CUDA", "MPI", "React"],
      systems: ["Linux", "Docker", "Kubernetes", "Slurm", "Git"]
    }
  }
};

// Initialize Gemini Bot
class GeminiBot {
  constructor() {
    this.conversationHistory = [];
    this.isTyping = false;
    this.useGemini = true; // Toggle for Gemini API usage
  }

  async generateGeminiResponse(message) {
    // Prepare context from conversation history
    const context = this.conversationHistory.slice(-5).map(h => 
      `${h.role}: ${h.content}`
    ).join('\n');

    const prompt = `${enhancedKnowledgeBase.systemPrompt}

Recent conversation:
${context}

User: ${message}

Provide a helpful, accurate response as Xuming Bot. If the question is about Xuming's work, research, or experience, use the provided context. For technical questions, explain clearly with examples when appropriate.`;

    try {
      const response = await fetch(`${GEMINI_API_URL}?key=${GEMINI_API_KEY}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          contents: [{
            parts: [{
              text: prompt
            }]
          }],
          generationConfig: {
            temperature: 0.7,
            maxOutputTokens: 500,
            topP: 0.8,
            topK: 40
          }
        })
      });

      if (!response.ok) {
        throw new Error(`API error: ${response.status}`);
      }

      const data = await response.json();
      return data.candidates[0].content.parts[0].text;
    } catch (error) {
      console.error('Gemini API error:', error);
      // Fallback to local response
      return this.generateLocalResponse(message);
    }
  }

  generateLocalResponse(message) {
    // Use the original bot.js logic as fallback
    return generateResponse(message);
  }

  async processMessage(message) {
    // Add user message to history
    this.conversationHistory.push({
      role: 'user',
      content: message
    });

    // Decide whether to use Gemini or local response
    let response;
    if (this.useGemini && this.shouldUseGemini(message)) {
      response = await this.generateGeminiResponse(message);
    } else {
      response = this.generateLocalResponse(message);
    }

    // Add bot response to history
    this.conversationHistory.push({
      role: 'assistant',
      content: response
    });

    return response;
  }

  shouldUseGemini(message) {
    // Use Gemini for complex or open-ended questions
    const complexKeywords = ['explain', 'how', 'why', 'compare', 'difference', 'advice', 'help me', 'tell me more', 'elaborate'];
    const lower = message.toLowerCase();
    
    // Always use local for quick facts about Xuming
    if (lower.includes('email') || lower.includes('contact') || lower.includes('github')) {
      return false;
    }
    
    // Use Gemini for complex questions
    return complexKeywords.some(keyword => lower.includes(keyword)) || message.length > 50;
  }
}

// Enhanced UI Functions
let geminiBot = new GeminiBot();

async function sendEnhancedMessage() {
  const input = document.getElementById('message-input');
  const message = input.value.trim();
  
  if (!message) return;
  
  // Add user message
  addEnhancedMessage(message, 'user');
  
  // Clear input
  input.value = '';
  
  // Show typing indicator
  showTypingIndicator();
  
  try {
    // Generate response
    const response = await geminiBot.processMessage(message);
    
    // Remove typing indicator
    hideTypingIndicator();
    
    // Add bot response with animation
    addEnhancedMessage(response, 'bot', true);
  } catch (error) {
    hideTypingIndicator();
    addEnhancedMessage("I'm having trouble connecting right now. Please try again or email Xuming directly.", 'bot');
  }
}

function addEnhancedMessage(text, sender, animate = false) {
  const messagesDiv = document.getElementById('messages');
  const messageDiv = document.createElement('div');
  messageDiv.className = `message ${sender}-message`;
  
  // Enhanced styling
  const styles = {
    user: {
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      color: 'white',
      marginLeft: 'auto',
      marginRight: '0',
      borderRadius: '12px 12px 4px 12px',
      maxWidth: '70%'
    },
    bot: {
      background: '#f8f9fa',
      color: '#333',
      marginLeft: '0',
      marginRight: 'auto',
      borderRadius: '12px 12px 12px 4px',
      maxWidth: '80%'
    }
  };
  
  Object.assign(messageDiv.style, {
    margin: '12px 0',
    padding: '12px 16px',
    ...styles[sender],
    boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
    transition: 'all 0.3s ease'
  });
  
  if (animate) {
    messageDiv.style.opacity = '0';
    messageDiv.style.transform = 'translateY(20px)';
  }
  
  // Format message content
  const formattedText = formatMessage(text, sender);
  messageDiv.innerHTML = formattedText;
  
  messagesDiv.appendChild(messageDiv);
  
  if (animate) {
    setTimeout(() => {
      messageDiv.style.opacity = '1';
      messageDiv.style.transform = 'translateY(0)';
    }, 50);
  }
  
  // Smooth scroll to bottom
  const container = document.getElementById('chat-container');
  container.scrollTo({
    top: container.scrollHeight,
    behavior: 'smooth'
  });
}

function formatMessage(text, sender) {
  // Enhanced formatting with markdown-like support
  let formatted = text
    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    .replace(/\*(.*?)\*/g, '<em>$1</em>')
    .replace(/`(.*?)`/g, '<code style="background:#e3f2fd; padding:2px 4px; border-radius:3px;">$1</code>')
    .replace(/\n/g, '<br>')
    .replace(/• /g, '&bull; ');
  
  if (sender === 'user') {
    return formatted;
  } else {
    // Add avatar for bot messages
    return `
      <div style="display: flex; align-items: start; gap: 10px;">
        <div style="width: 32px; height: 32px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
          <span style="color: white; font-size: 16px;">X</span>
        </div>
        <div style="flex: 1;">
          <div style="font-weight: bold; margin-bottom: 4px; color: #1772d0;">Xuming Bot</div>
          ${formatted}
        </div>
      </div>
    `;
  }
}

function showTypingIndicator() {
  const messagesDiv = document.getElementById('messages');
  const typingDiv = document.createElement('div');
  typingDiv.id = 'typing-indicator';
  typingDiv.className = 'message bot-message';
  typingDiv.style.cssText = `
    margin: 12px 0;
    padding: 12px 16px;
    background: #f8f9fa;
    borderRadius: 12px;
    maxWidth: 80px;
    display: flex;
    align-items: center;
    gap: 4px;
  `;
  
  // Create animated dots
  for (let i = 0; i < 3; i++) {
    const dot = document.createElement('span');
    dot.style.cssText = `
      width: 8px;
      height: 8px;
      background: #999;
      border-radius: 50%;
      animation: typing 1.4s infinite;
      animation-delay: ${i * 0.2}s;
    `;
    typingDiv.appendChild(dot);
  }
  
  messagesDiv.appendChild(typingDiv);
  
  // Add animation styles if not already present
  if (!document.getElementById('typing-animation')) {
    const style = document.createElement('style');
    style.id = 'typing-animation';
    style.textContent = `
      @keyframes typing {
        0%, 60%, 100% { opacity: 0.3; transform: translateY(0); }
        30% { opacity: 1; transform: translateY(-10px); }
      }
    `;
    document.head.appendChild(style);
  }
}

function hideTypingIndicator() {
  const indicator = document.getElementById('typing-indicator');
  if (indicator) {
    indicator.remove();
  }
}

// Quick action buttons
function addQuickActions() {
  const quickActions = [
    { text: "📚 Research", query: "Tell me about your research in ML systems" },
    { text: "🎓 Stanford", query: "What was your Stanford experience?" },
    { text: "🏆 Achievements", query: "What are your main achievements?" },
    { text: "💻 Projects", query: "Show me your featured projects" },
    { text: "🤝 Collaborate", query: "How can we collaborate?" }
  ];
  
  const container = document.createElement('div');
  container.style.cssText = `
    display: flex;
    gap: 8px;
    margin: 10px 0;
    flex-wrap: wrap;
  `;
  
  quickActions.forEach(action => {
    const button = document.createElement('button');
    button.textContent = action.text;
    button.style.cssText = `
      padding: 6px 12px;
      background: white;
      border: 1px solid #ddd;
      border-radius: 16px;
      cursor: pointer;
      transition: all 0.2s;
      font-size: 14px;
    `;
    button.onmouseover = () => {
      button.style.background = '#e3f2fd';
      button.style.borderColor = '#1772d0';
    };
    button.onmouseout = () => {
      button.style.background = 'white';
      button.style.borderColor = '#ddd';
    };
    button.onclick = () => {
      document.getElementById('message-input').value = action.query;
      sendEnhancedMessage();
    };
    container.appendChild(button);
  });
  
  return container;
}

// Export for use in bot.html
window.sendMessage = sendEnhancedMessage;
window.askQuestion = function(question) {
  document.getElementById('message-input').value = question;
  sendEnhancedMessage();
};

// Initialize on load
document.addEventListener('DOMContentLoaded', function() {
  // Add quick actions below input
  const inputContainer = document.querySelector('#message-input').parentElement;
  inputContainer.appendChild(addQuickActions());
});