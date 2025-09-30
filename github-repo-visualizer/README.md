# GitHub Repository Visualizer

A powerful, interactive visualization tool for exploring GitHub repositories. View commit history, branch networks, contributor graphs, and more - all in your browser.

![GitHub Repo Visualizer Demo](demo.png)

## Features

- **Repository Statistics**: Stars, forks, issues, and recent commit counts
- **Language Breakdown**: Visual pie chart showing language distribution
- **Commit History Timeline**: Interactive visualization of recent commits
- **Branch Network**: Visual representation of repository branches
- **Contributor Network**: Force-directed graph showing contributor relationships
- **File Structure Treemap**: Visual representation of repository structure
- **Activity Chart**: Line graph showing commit activity over time

## Live Demo

Try it out: [GitHub Repository Visualizer](https://yourusername.github.io/github-repo-visualizer/)

## Usage

### Option 1: Standalone HTML File
Simply open `index.html` in your browser and enter any public GitHub repository URL.

### Option 2: Integrate into Your Project
```html
<!-- Include required libraries -->
<script src="https://d3js.org/d3.v7.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- Include the visualizer -->
<script src="github-repo-visualizer.js"></script>
```

### Example URLs to Try
- https://github.com/facebook/react
- https://github.com/vuejs/vue
- https://github.com/tensorflow/tensorflow
- https://github.com/microsoft/vscode

## API Rate Limiting

This tool uses the GitHub API which has rate limits:
- **Unauthenticated requests**: 60 requests per hour
- **Authenticated requests**: 5,000 requests per hour (requires API token)

To use with authentication, modify the `fetchGitHubAPI` function to include your token:
```javascript
headers: {
    'Authorization': 'token YOUR_GITHUB_TOKEN'
}
```

## Technologies Used

- **D3.js**: For creating interactive data visualizations
- **Chart.js**: For creating responsive charts
- **GitHub API**: For fetching repository data
- **Vanilla JavaScript**: No framework dependencies
- **CSS3**: Modern styling with gradients and animations

## Project Structure

```
github-repo-visualizer/
├── index.html           # Main application file
├── README.md           # Documentation
├── LICENSE             # MIT License
├── demo.png           # Demo screenshot
└── examples/          # Example implementations
    └── integration.html
```

## Features in Detail

### 1. Repository Statistics
Displays key metrics including stars, forks, open issues, and recent commit count with formatted numbers (e.g., 1.2K, 3.4M).

### 2. Language Distribution
Doughnut chart showing the percentage breakdown of languages used in the repository.

### 3. Commit History
Interactive timeline showing recent commits with:
- Commit messages
- Author information
- Timestamps
- Hover tooltips for details

### 4. Branch Network
Visual representation of repository branches showing:
- Main branch
- Feature branches
- Branch relationships

### 5. Contributor Network
Force-directed graph displaying:
- Contributor nodes sized by contribution count
- Relationships between top contributors
- Interactive drag and zoom capabilities

### 6. File Structure
Treemap visualization showing:
- Repository file structure
- File types and sizes
- Color-coded by type (tree/blob)

## Browser Compatibility

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Future Enhancements

- [ ] Add authentication support for higher API limits
- [ ] Implement caching to reduce API calls
- [ ] Add export functionality for visualizations
- [ ] Support for private repositories
- [ ] Add more visualization types (issues, PRs, releases)
- [ ] Dark mode toggle
- [ ] Mobile responsive improvements
- [ ] Add loading animations
- [ ] Implement error recovery mechanisms

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Created by [Xuming Huang](https://github.com/yourusername)

## Acknowledgments

- Inspired by [git-school/visualizing-git](https://git-school.github.io/visualizing-git/)
- Thanks to the D3.js and Chart.js communities
- GitHub API documentation

## Support

If you find this project useful, please consider giving it a ⭐ on GitHub!

For issues, questions, or suggestions, please [open an issue](https://github.com/yourusername/github-repo-visualizer/issues).