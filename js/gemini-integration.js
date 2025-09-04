// Gemini API Integration for Xuming Bot
// Simple integration that enhances bot responses using Google's Gemini API

const GEMINI_API_KEY = 'AIzaSyAllu6kCLJqR9s2EFemZ4wvcwRaoCv6dtA';

// Enhanced knowledge context for Gemini
const xumingContext = `You are Xuming Bot, representing Xuming Huang, a junior CS student at UW-Madison.
Key facts about Xuming:
- Stanford Summer 2025: CS107 (A+, 99/100), CS161 (A, 93/100)
- Discovered critical vulnerabilities in Stanford's AFS system
- NFL FLAG Football National Champion 2023
- Research focus: ML Systems, distributed training, compiler optimization
- Created popular interactive CS visualizations
- Skills: C/C++, Python, CUDA, PyTorch, systems programming
- Current courses at UW-Madison: Computer Engineering, Linear Algebra, Discrete Mathematics
- Interests: Making ML training more efficient through systems optimization

Respond concisely and accurately. For technical questions, provide clear explanations.`;

// Gemini API caller
async function callGeminiAPI(userMessage) {
  // Use the correct Gemini 1.5 Flash endpoint
  const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=${GEMINI_API_KEY}`;
  
  const requestBody = {
    contents: [{
      parts: [{
        text: `${xumingContext}\n\nUser Question: ${userMessage}\n\nProvide a helpful, informative response as Xuming Bot.`
      }]
    }],
    generationConfig: {
      temperature: 0.7,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 400,
    },
    safetySettings: [
      {
        category: "HARM_CATEGORY_HARASSMENT",
        threshold: "BLOCK_NONE"
      },
      {
        category: "HARM_CATEGORY_HATE_SPEECH",
        threshold: "BLOCK_NONE"
      },
      {
        category: "HARM_CATEGORY_SEXUALLY_EXPLICIT",
        threshold: "BLOCK_NONE"
      },
      {
        category: "HARM_CATEGORY_DANGEROUS_CONTENT",
        threshold: "BLOCK_NONE"
      }
    ]
  };

  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(requestBody)
    });

    if (!response.ok) {
      console.error('API Error:', response.status, response.statusText);
      // Try to get error details
      try {
        const errorData = await response.json();
        console.error('Error details:', errorData);
      } catch (e) {
        console.error('Could not parse error response');
      }
      return null;
    }

    const data = await response.json();
    if (data.candidates && data.candidates[0] && data.candidates[0].content) {
      return data.candidates[0].content.parts[0].text;
    }
    return null;
  } catch (error) {
    console.error('Failed to call Gemini API:', error);
    return null;
  }
}

// Override the original sendMessage function with Gemini enhancement
const originalSendMessage = window.sendMessage || function() {
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
};

// Enhanced send message with Gemini
window.sendMessage = async function() {
  const input = document.getElementById('message-input');
  const message = input.value.trim();
  
  if (!message) return;
  
  // Add user message
  addMessage(message, 'user');
  
  // Clear input
  input.value = '';
  
  // Show typing indicator
  const messagesDiv = document.getElementById('messages');
  const typingDiv = document.createElement('div');
  typingDiv.className = 'bot-message typing-indicator';
  typingDiv.innerHTML = '<strong>Xuming Bot:</strong> <em style="color: #666;">typing...</em>';
  typingDiv.style.opacity = '0.7';
  messagesDiv.appendChild(typingDiv);
  
  // Scroll to bottom
  const container = document.getElementById('chat-container');
  container.scrollTop = container.scrollHeight;
  
  // Determine if we should use Gemini
  const useGemini = shouldUseGemini(message);
  
  if (useGemini) {
    // Try Gemini first
    const geminiResponse = await callGeminiAPI(message);
    
    // Remove typing indicator
    typingDiv.remove();
    
    if (geminiResponse) {
      // Add a subtle indicator for AI-enhanced responses
      addMessage(geminiResponse + '\n\n<small style="color: #999; font-size: 11px;">[AI-enhanced response]</small>', 'bot');
    } else {
      // Fallback to local response
      const localResponse = generateResponse(message);
      addMessage(localResponse, 'bot');
    }
  } else {
    // Use local response for simple queries
    setTimeout(() => {
      typingDiv.remove();
      const response = generateResponse(message);
      addMessage(response, 'bot');
    }, 300);
  }
};

// Determine when to use Gemini
function shouldUseGemini(message) {
  const lower = message.toLowerCase();
  
  // Don't use Gemini for simple lookups
  const simpleQueries = ['email', 'contact', 'github', 'name', 'who are you', 'hello', 'hi'];
  if (simpleQueries.some(q => lower.includes(q)) && message.length < 30) {
    return false;
  }
  
  // Always use local for certain Xuming-specific queries
  if (lower.includes('stanford') && message.length < 40) {
    return false; // Use local for quick Stanford facts
  }
  
  // Use Gemini for complex questions
  const complexIndicators = [
    'explain', 'how does', 'how do', 'why', 'what is the difference',
    'compare', 'tell me more', 'elaborate', 'detail',
    'help me understand', 'can you teach', 'example',
    'describe', 'what are', 'when should', 'best practice'
  ];
  
  // Use Gemini if message is complex, long, or technical
  return complexIndicators.some(indicator => lower.includes(indicator)) || 
         message.length > 50 ||
         (message.includes('?') && message.length > 20);
}

// Add subtle indicator when using Gemini
const originalAddMessage = window.addMessage;
window.addMessage = function(text, sender) {
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
};

console.log('Gemini integration loaded successfully');