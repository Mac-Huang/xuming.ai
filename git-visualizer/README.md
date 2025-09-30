# Git Visualizer - Learn Git Interactively

An interactive visualization tool that helps you understand Git commands by showing their effects on repository structure in real-time. Inspired by git-school/visualizing-git.

![Git Visualizer Demo](demo.gif)

## 🎯 Purpose

Understanding Git can be challenging for beginners. This tool simplifies version control concepts by:
- **Visualizing git operations** as they happen
- **Interactive command input** - type real git commands
- **Step-by-step tutorials** for common workflows
- **Instant visual feedback** showing how commands affect the repository

## ✨ Features

### Interactive Command Line
- Type actual git commands like `git commit`, `git branch feature`, `git merge`
- See immediate visual feedback
- Command history and error messages
- Autocomplete suggestions for commands

### Visual Git Graph
- Commits shown as nodes
- Branches displayed with different colors
- HEAD pointer clearly marked
- Merge commits with multiple parents
- Tags and stash visualization

### Supported Git Commands
- `git commit` - Create new commits
- `git branch [name]` - Create and list branches
- `git checkout [branch/commit]` - Switch branches or detach HEAD
- `git merge [branch]` - Merge branches
- `git rebase [branch]` - Rebase commits
- `git reset [commit]` - Reset to specific commit
- `git cherry-pick [commit]` - Apply specific commits
- `git tag [name]` - Create tags
- `git stash` - Save work temporarily
- `git log` - View commit history

### Learning Modes

#### Tutorial Mode
Step-by-step scenarios teaching:
- Basic commands (commit, branch, merge)
- Branching strategies
- Rebasing vs merging
- Cherry-picking commits
- Handling merge conflicts
- Using tags and releases
- Stashing changes

#### Sandbox Mode
- Free exploration environment
- Experiment with any git command
- No restrictions or guidance
- Perfect for practicing

## 🚀 Live Demo

Try it now: [Git Visualizer Demo](https://yourusername.github.io/git-visualizer/)

## 🛠️ Usage

### Option 1: Standalone HTML
Simply open `index.html` in any modern browser. No installation required!

### Option 2: Host Locally
```bash
# Clone the repository
git clone https://github.com/yourusername/git-visualizer.git

# Navigate to directory
cd git-visualizer

# Open in browser
open index.html
# Or serve with any HTTP server
python -m http.server 8000
```

### Option 3: Embed in Your Site
```html
<iframe src="path/to/git-visualizer.html" width="100%" height="600"></iframe>
```

## 📚 Tutorial Scenarios

### 1. Basic Commands
Learn fundamental Git operations:
- Creating commits
- Creating branches
- Switching between branches
- Merging branches

### 2. Branching Strategy
Master feature branch workflow:
- Create feature branches
- Develop in isolation
- Merge back to main branch

### 3. Rebasing
Clean up your commit history:
- Linear vs branched history
- Interactive rebasing
- Squashing commits

### 4. Cherry-pick
Select specific commits:
- Apply commits from other branches
- Skip unwanted changes

### 5. Merge Conflicts
Handle conflicts gracefully:
- Understand conflict markers
- Resolve conflicts
- Complete the merge

## 🎨 Customization

### Color Scheme
Branches use different colors for clarity:
- `master/main`: Blue (#61afef)
- `feature`: Green (#98c379)
- `develop`: Red (#e06c75)
- `hotfix`: Orange (#d19a66)

### Configuration
Edit the `config` object in the code:
```javascript
const config = {
    nodeRadius: 20,        // Size of commit nodes
    commitSpacing: 80,     // Horizontal spacing
    branchSpacing: 60,     // Vertical spacing
    animationDuration: 500 // Animation speed (ms)
};
```

## 🏗️ Technical Details

### Pure JavaScript Implementation
- No external dependencies for core functionality
- Lightweight SVG rendering
- Works in all modern browsers

### Architecture
- **State Management**: Single source of truth for git repository state
- **Command Parser**: Interprets git commands and updates state
- **Visualization Engine**: Renders state changes to SVG
- **Tutorial System**: Guides users through scenarios

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Ideas for Contribution
- Add more git commands (fetch, pull, push)
- Create new tutorial scenarios
- Improve animations
- Add sound effects
- Support for remote repositories
- Multi-language support

## 📋 Roadmap

- [ ] Add git fetch/pull/push visualization
- [ ] Remote repository simulation
- [ ] Conflict resolution interface
- [ ] Interactive rebase editor
- [ ] Git flow visualization
- [ ] Export/import repository state
- [ ] Mobile responsive design
- [ ] Keyboard shortcuts
- [ ] Dark/light theme toggle

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by [git-school/visualizing-git](https://git-school.github.io/visualizing-git/)
- Git logo and branding are trademarks of Software Freedom Conservancy
- Thanks to all contributors and users

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/git-visualizer/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/git-visualizer/discussions)
- **Email**: your.email@example.com

## ⭐ Show Your Support

If this project helped you learn Git, please give it a star on GitHub!

---

Made with ❤️ for the developer community