# 🎓 Academic Portfolio Template

A **clean, minimal, and professional** academic portfolio template inspired by [Jon Barron's website](https://jonbarron.info/). Built with vanilla HTML/CSS/JavaScript - no frameworks needed!

## ✨ Live Demo

Check out the live demo: [xuming.ai](https://xuming.ai)

## 🚀 Quick Start (< 5 minutes)

### Option 1: Use as GitHub Template
1. Click the "Use this template" button above
2. Name your repo `[username].github.io` for automatic hosting
3. Clone and customize with your content
4. Push changes - your site will be live at `https://[username].github.io`

### Option 2: Clone and Deploy
```bash
# Clone the repository
git clone https://github.com/Mac-Huang/xuming.ai.git my-portfolio
cd my-portfolio

# Test locally
python -m http.server 8000
# Visit http://localhost:8000

# Deploy to GitHub Pages
git remote set-url origin https://github.com/[your-username]/[your-username].github.io.git
git push origin main
```

## 📋 Features

✅ **Zero Dependencies** - Pure HTML/CSS/JS, no build process needed
✅ **Responsive Design** - Looks great on all devices
✅ **Fast Loading** - Minimal and optimized
✅ **SEO Friendly** - Semantic HTML with proper meta tags
✅ **Multiple Sections** - Research, Projects, Blog, Teaching, and more
✅ **Interactive Demos** - Showcase your work with live examples
✅ **Dark Mode Support** - Easy to add with CSS variables
✅ **Customizable** - Simple structure, easy to modify

## 📁 Project Structure

```
📦 your-portfolio/
├── 📄 index.html           # Home page with bio and highlights
├── 📄 research.html        # Publications and research projects
├── 📄 projects.html        # Project showcase with filtering
├── 📄 blog.html            # Blog posts listing
├── 📄 courses.html         # Teaching and courses
├── 📄 bot.html             # AI assistant (optional)
├── 🎨 stylesheet.css       # Main styles (customize colors here!)
├── 📁 data/
│   ├── projects.js         # Project data (easy to update)
│   └── publications.js     # Publication data
├── 📁 demos/               # Interactive project demos
├── 📁 blog/posts/          # Blog post HTML files
├── 📁 js/                  # JavaScript functionality
├── 📁 images/              # Images and assets
└── 📁 cv/                  # Resume/CV files
```

## 🎨 Customization Guide

### 1️⃣ Personal Information
Edit `index.html`:
```html
<!-- Update your name -->
<name>Your Name</name>

<!-- Update your bio -->
<p>Your research interests and current work...</p>

<!-- Update contact links -->
<a href="your-cv.pdf">CV</a>
<a href="https://github.com/your-username">GitHub</a>
```

### 2️⃣ Profile Photo
Replace `images/profile.jpg` with your photo (square aspect ratio recommended)

### 3️⃣ Projects
Edit `data/projects.js`:
```javascript
const projects = [
  {
    id: 'project-id',
    title: 'Your Project Title',
    description: 'Project description',
    tech: 'Python, PyTorch, etc.',
    thumbnail: 'images/projects/your-thumb.jpg',
    demo_url: 'demos/your-demo.html',
    code_url: 'https://github.com/your-repo',
    featured: true
  },
  // Add more projects...
];
```

### 4️⃣ Publications
Edit `data/publications.js` to add your papers

### 5️⃣ Color Scheme
Edit `stylesheet.css`:
```css
:root {
  --primary-color: #1772d0;  /* Change main color */
  --text-color: #333;
  --bg-color: #ffffff;
}
```

### 6️⃣ Blog Posts
Create new HTML files in `blog/posts/` and link them in `blog.html`

## 🔧 Advanced Features

### Adding Interactive Demos
1. Create demo HTML in `demos/` folder
2. Include D3.js, Three.js, or any library via CDN
3. Link from projects.js

### Email Obfuscation
The template includes JavaScript-based email protection in `js/main.js`

### SEO Optimization
- Update meta tags in each HTML file
- Add structured data for better search results
- Customize Open Graph tags for social sharing

## 🚢 Deployment Options

### GitHub Pages (Recommended)
1. Push to repo named `[username].github.io`
2. Enable Pages in Settings → Pages
3. Select main branch and root folder

### Netlify
1. Connect your GitHub repo
2. Auto-deploys on push
3. Custom domain support

### Vercel
```bash
npm i -g vercel
vercel --prod
```

## 📝 Tips for Academics

- **Papers First**: Lead with your publications on the homepage
- **Visual Projects**: Include screenshots/GIFs in project cards
- **Blog Regularly**: Share research insights and tutorials
- **Link Everything**: Connect papers, code, slides, and videos
- **Update Often**: Keep publications and projects current

## 🤝 Contributing

Found a bug or have a feature request? Please open an issue!

Pull requests are welcome. For major changes, please open an issue first.

## 📄 License

MIT License - feel free to use this template for your academic website!

## 🙏 Acknowledgments

- Design inspired by [Jon Barron](https://jonbarron.info/)
- Icons from [Font Awesome](https://fontawesome.com/)
- Hosted on [GitHub Pages](https://pages.github.com/)

---

**⭐ If this template helped you, please consider giving it a star!**

*Built with ❤️ for the academic community*

