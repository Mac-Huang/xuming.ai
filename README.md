# Xuming Huang - Academic Portfolio

A minimal academic portfolio website inspired by Jon Barron's design philosophy, built with vanilla HTML, CSS, and JavaScript.

🌐 **Live Site**: [xuming.ai](https://xuming.ai)

## Overview

This portfolio showcases my research in Machine Learning Systems, ongoing projects, and academic journey at the University of Wisconsin-Madison. The site features interactive MLSys demonstrations, a blog, and a minimal AI assistant.

## Features

### 📚 Research & Publications
- Current research projects in kernel security analysis and heterogeneous computing
- LinuxGuard: AI-Powered Kernel Security Analysis
- Heterogeneous Task Scheduler for CPU-GPU Systems
- Multispectral U-Net Segmentation Research

### 🚀 Projects
**Machine Learning Projects:**
- CIFAR-10 Image Classification
- Word2Vec Implementation
- LSTM Tasks Suite
- Neural Machine Translator

**Interactive MLSys Demos:**
- Neural Network Training Visualizer
- Distributed Training Simulator
- Model Compression Playground
- Memory Management Visualizer
- Pipeline Parallelism Demo

### 📝 Blog
Personal blog posts about:
- Life experiences in Madison, Wisconsin
- Internship at CoolAI and WAIC experience
- NFL Flag Football Championship victory
- Academic journey and reflections

### 📖 Courses
Detailed documentation of coursework at UW-Madison:
- COMP SCI 200: Programming I
- E C E 252: Introduction to Computer Engineering
- MATH 340: Elementary Matrix and Linear Algebra
- COMP SCI 240: Introduction to Discrete Mathematics

### 🎓 Teaching & Tutorials
- Understanding Transformers - Comprehensive tutorial
- GPT Implementation Guide - Step-by-step implementation

### 🤖 Interactive Bot
A simple keyword-based assistant providing information about my academic work and research interests.

## Tech Stack

- **Frontend**: Pure HTML, CSS, JavaScript (no frameworks)
- **Visualizations**: D3.js for data visualization
- **ML Demos**: TensorFlow.js for in-browser machine learning
- **Styling**: Minimal design inspired by Jon Barron's academic style
- **Color Scheme**: Primary blue (#1772d0) with clean typography

## Project Structure

```
xuming-portfolio/
├── index.html              # Main portfolio page
├── research.html           # Research and publications
├── projects.html           # Project showcase
├── blog.html              # Blog listing
├── courses.html           # Course documentation
├── bot.html               # Interactive assistant
├── stylesheet.css         # Main styles
├── data/
│   ├── publications.js    # Research data
│   ├── projects.js        # Projects data
│   └── blog-posts.js      # Blog entries
├── demos/
│   ├── neural-training.html
│   ├── distributed-training.html
│   ├── model-compression.html
│   ├── memory-management.html
│   ├── pipeline-parallel.html
│   ├── sorting.html
│   ├── graphs.html
│   └── neural.html
├── blog/posts/
│   ├── hello-world.html
│   ├── first-internship.html
│   ├── new-chapter-madison.html
│   └── nfl-flag-football-championship.html
├── js/
│   ├── main.js            # Main JavaScript
│   └── bot.js             # Bot functionality
└── images/
    └── [various images]
```

## Local Development

1. Clone the repository:
```bash
git clone https://github.com/Mac-Huang/xuming.ai.git
cd xuming.ai
```

2. Open `index.html` in your browser or use a local server:
```bash
# Using Python
python -m http.server 8000

# Using Node.js
npx http-server
```

3. Navigate to `http://localhost:8000`

## Customization

To adapt this template for your own use:

1. Update personal information in `index.html`
2. Modify data files in the `data/` directory
3. Replace images in the `images/` folder
4. Customize the color scheme in `stylesheet.css` (primary color: #1772d0)
5. Update email in `js/main.js`

## Design Philosophy

This portfolio follows Jon Barron's minimalist design principles:
- Clean, table-based layout
- Serif fonts for readability
- Minimal JavaScript, no heavy frameworks
- Focus on content over flashy design
- Fast loading and accessible

## Contact

**Xuming Huang**  
University of Wisconsin - Madison  
Email: xuming@stanford.edu  
GitHub: [@Mac-Huang](https://github.com/Mac-Huang)  
LinkedIn: [Xuming Huang](https://www.linkedin.com/in/xuminghuang/)

## License

Feel free to use this template for your own academic portfolio. Please provide attribution if you use substantial portions of the code.

---

*Built with ❤️ for the academic community*
