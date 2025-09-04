// Main JavaScript for portfolio site - minimal and clean like Jon Barron's approach
// No frameworks, just vanilla JavaScript

// Current filter state
let currentFilter = 'all';

// Show email function
function showEmail() {
  const email = 'xuming' + '@' + 'stanford.edu';
  const emailLink = document.getElementById('email-link');
  if (emailLink) {
    emailLink.innerHTML = '<a href="mailto:' + email + '">' + email + '</a>';
  }
}

// Create a publication row following Jon Barron's exact style
function createPublicationRow(pub) {
  const tr = document.createElement('tr');
  
  // Add background color for selected papers
  if (pub.selected) {
    tr.style.backgroundColor = '#ffffd0';
  }
  
  // Image column (25% width, 160px images)
  const tdImage = document.createElement('td');
  tdImage.style.cssText = 'padding:20px;width:25%;vertical-align:middle';
  
  if (pub.image) {
    const img = document.createElement('img');
    img.src = pub.image;
    img.alt = pub.title;
    img.width = 160;
    img.style.borderStyle = 'none';
    tdImage.appendChild(img);
  }
  
  tr.appendChild(tdImage);
  
  // Content column (75% width)
  const tdContent = document.createElement('td');
  tdContent.style.cssText = 'padding:20px;width:75%;vertical-align:middle';
  
  // Paper title as link
  if (pub.paper_url) {
    const titleLink = document.createElement('a');
    titleLink.href = pub.paper_url;
    const titleSpan = document.createElement('papertitle');
    titleSpan.textContent = pub.title;
    titleLink.appendChild(titleSpan);
    tdContent.appendChild(titleLink);
  } else {
    const titleSpan = document.createElement('papertitle');
    titleSpan.textContent = pub.title;
    tdContent.appendChild(titleSpan);
  }
  tdContent.appendChild(document.createElement('br'));
  
  // Authors (with your name in bold, already formatted in data)
  const authorsDiv = document.createElement('div');
  authorsDiv.innerHTML = pub.authors;
  tdContent.appendChild(authorsDiv);
  
  // Venue and year in italics
  const venueEm = document.createElement('em');
  venueEm.textContent = pub.venue;
  if (pub.year) {
    venueEm.textContent += ', ' + pub.year;
  }
  tdContent.appendChild(venueEm);
  tdContent.appendChild(document.createElement('br'));
  
  // Links row (paper / code / project / bibtex)
  const links = [];
  if (pub.paper_url) {
    links.push('<a href="' + pub.paper_url + '">paper</a>');
  }
  if (pub.code_url) {
    links.push('<a href="' + pub.code_url + '">code</a>');
  }
  if (pub.project_url) {
    links.push('<a href="' + pub.project_url + '">project</a>');
  }
  if (pub.bibtex) {
    links.push('<a href="javascript:void(0)" onclick="showBibTeX(\'' + pub.id + '\')">bibtex</a>');
  }
  
  if (links.length > 0) {
    const linksDiv = document.createElement('div');
    linksDiv.innerHTML = links.join(' / ');
    tdContent.appendChild(linksDiv);
  }
  
  // Abstract/description if available
  if (pub.abstract) {
    const p = document.createElement('p');
    p.textContent = pub.abstract;
    p.style.marginTop = '5px';
    tdContent.appendChild(p);
  }
  
  tr.appendChild(tdContent);
  
  // Store publication data for bibtex modal
  tr.dataset.pubId = pub.id;
  tr.dataset.bibtex = pub.bibtex || '';
  tr.dataset.category = pub.category || 'conference';
  
  return tr;
}

// Load all publications
function loadPublications(filter = 'all') {
  const table = document.getElementById('publications-table');
  if (!table || typeof publications === 'undefined') return;
  
  // Clear existing rows
  const tbody = table.querySelector('tbody') || table;
  tbody.innerHTML = '';
  
  // Get filtered publications
  let filteredPubs = getPublicationsByCategory(filter);
  
  // Sort by year (descending) and then by selected status
  filteredPubs.sort((a, b) => {
    if (a.year !== b.year) return b.year - a.year;
    if (a.selected !== b.selected) return b.selected ? 1 : -1;
    return 0;
  });
  
  // Create and append rows
  filteredPubs.forEach(pub => {
    const row = createPublicationRow(pub);
    tbody.appendChild(row);
  });
}

// Load selected publications only (for home page)
function loadSelectedPublications() {
  const table = document.getElementById('selected-publications');
  if (!table || typeof publications === 'undefined') return;
  
  const tbody = table.querySelector('tbody') || table;
  tbody.innerHTML = '';
  
  const selectedPubs = getSelectedPublications();
  
  // Sort by year (descending)
  selectedPubs.sort((a, b) => b.year - a.year);
  
  // Create and append rows
  selectedPubs.forEach(pub => {
    const row = createPublicationRow(pub);
    tbody.appendChild(row);
  });
}

// Filter publications (smooth show/hide)
function filterPublications(category) {
  currentFilter = category;
  
  // Update filter button states
  document.querySelectorAll('.filter-btn').forEach(btn => {
    btn.classList.remove('active');
    if (btn.dataset.filter === category) {
      btn.classList.add('active');
    }
  });
  
  // Reload publications with filter
  loadPublications(category);
}

// Show BibTeX modal
function showBibTeX(pubId) {
  const pub = publications.find(p => p.id === pubId);
  if (!pub || !pub.bibtex) return;
  
  // Create modal if it doesn't exist
  let modal = document.getElementById('bibtex-modal');
  if (!modal) {
    modal = createBibTeXModal();
  }
  
  // Update modal content
  const bibtexContent = document.getElementById('bibtex-content');
  const bibtexText = document.getElementById('bibtex-text');
  
  bibtexContent.textContent = pub.bibtex;
  bibtexText.value = pub.bibtex;
  
  // Show modal
  modal.style.display = 'block';
  document.body.style.overflow = 'hidden';
}

// Create BibTeX modal
function createBibTeXModal() {
  const modal = document.createElement('div');
  modal.id = 'bibtex-modal';
  modal.className = 'modal';
  modal.innerHTML = `
    <div class="modal-content">
      <div class="modal-header">
        <span class="modal-title">BibTeX</span>
        <span class="modal-close" onclick="closeBibTeX()">&times;</span>
      </div>
      <div class="modal-body">
        <pre id="bibtex-content"></pre>
        <textarea id="bibtex-text" style="position:absolute;left:-9999px;"></textarea>
        <button class="copy-btn" onclick="copyBibTeX()">Copy to Clipboard</button>
      </div>
    </div>
  `;
  
  document.body.appendChild(modal);
  
  // Close on background click
  modal.onclick = function(event) {
    if (event.target === modal) {
      closeBibTeX();
    }
  };
  
  return modal;
}

// Close BibTeX modal
function closeBibTeX() {
  const modal = document.getElementById('bibtex-modal');
  if (modal) {
    modal.style.display = 'none';
    document.body.style.overflow = 'auto';
  }
}

// Copy BibTeX to clipboard
function copyBibTeX() {
  const bibtexText = document.getElementById('bibtex-text');
  if (bibtexText) {
    bibtexText.select();
    document.execCommand('copy');
    
    // Show feedback
    const copyBtn = document.querySelector('.copy-btn');
    const originalText = copyBtn.textContent;
    copyBtn.textContent = 'Copied!';
    copyBtn.style.backgroundColor = '#51cf66';
    
    setTimeout(() => {
      copyBtn.textContent = originalText;
      copyBtn.style.backgroundColor = '';
    }, 2000);
  }
}

// Add filter buttons to page
function addFilterButtons() {
  const filterContainer = document.getElementById('publication-filters');
  if (!filterContainer) return;
  
  // No filters needed - commented out for now
  // const filters = [
  //   { label: 'All', value: 'all' },
  //   { label: 'Selected', value: 'selected' },
  //   { label: 'Conference', value: 'conference' },
  //   { label: 'Journal', value: 'journal' },
  //   { label: 'Preprint', value: 'preprint' }
  // ];
  
  // filters.forEach(filter => {
  //   const btn = document.createElement('button');
  //   btn.className = 'filter-btn';
  //   btn.dataset.filter = filter.value;
  //   btn.textContent = filter.label;
  //   btn.onclick = () => filterPublications(filter.value);
  //   
  //   if (filter.value === currentFilter) {
  //     btn.classList.add('active');
  //   }
  //   
  //   filterContainer.appendChild(btn);
  // });
}

// Create a project row following Jon Barron's style
function createProjectRow(project) {
  const tr = document.createElement('tr');
  
  // Highlight representative projects with subtle background
  if (project.featured && project.highlighted) {
    tr.style.cssText = 'background-color: #f9f9f9;';
  }
  
  // Image column (25% width, 160px images)
  const tdImage = document.createElement('td');
  tdImage.style.cssText = 'padding:20px;width:25%;vertical-align:middle';
  
  if (project.thumbnail) {
    const img = document.createElement('img');
    img.src = project.thumbnail;
    img.alt = project.title;
    img.width = 160;
    img.style.borderStyle = 'none';
    tdImage.appendChild(img);
  }
  
  tr.appendChild(tdImage);
  
  // Content column (75% width)
  const tdContent = document.createElement('td');
  tdContent.style.cssText = 'padding:20px;width:75%;vertical-align:middle';
  
  // Project title
  const titleSpan = document.createElement('papertitle');
  titleSpan.textContent = project.title;
  tdContent.appendChild(titleSpan);
  tdContent.appendChild(document.createElement('br'));
  
  // Technologies
  if (project.tech) {
    const techEm = document.createElement('em');
    techEm.textContent = 'Technologies: ' + project.tech;
    tdContent.appendChild(techEm);
    tdContent.appendChild(document.createElement('br'));
  }
  
  // Description
  if (project.description) {
    const descP = document.createElement('p');
    descP.textContent = project.description;
    descP.style.marginTop = '5px';
    descP.style.marginBottom = '5px';
    tdContent.appendChild(descP);
  }
  
  // Links (demo / code)
  const links = [];
  if (project.demo_url) {
    links.push('[<a href="' + project.demo_url + '">Live Demo</a>]');
  }
  if (project.code_url) {
    links.push('[<a href="' + project.code_url + '">Code</a>]');
  }
  
  if (links.length > 0) {
    const linksDiv = document.createElement('div');
    linksDiv.innerHTML = links.join(' ');
    tdContent.appendChild(linksDiv);
  }
  
  tr.appendChild(tdContent);
  return tr;
}

// Load all projects
function loadProjects() {
  const table = document.getElementById('projects-table');
  if (!table || typeof projects === 'undefined') return;
  
  const tbody = table.querySelector('tbody') || table;
  tbody.innerHTML = '';
  
  // Create and append rows for all projects
  projects.forEach(project => {
    const row = createProjectRow(project);
    tbody.appendChild(row);
  });
}

// Load featured projects (for home page if needed)
function loadFeaturedProjects() {
  const table = document.getElementById('featured-projects');
  if (!table || typeof projects === 'undefined') return;
  
  const tbody = table.querySelector('tbody') || table;
  tbody.innerHTML = '';
  
  const featuredProjects = getFeaturedProjects();
  
  featuredProjects.forEach(project => {
    const row = createProjectRow(project);
    tbody.appendChild(row);
  });
}

// Blog functionality
let currentBlogCategory = 'all';

// Create blog post element
function createBlogPost(post) {
  const table = document.createElement('table');
  table.style.cssText = 'width:100%;border:0px;border-spacing:0px;border-collapse:separate;margin-right:auto;margin-left:auto;';
  
  const tbody = document.createElement('tbody');
  const tr = document.createElement('tr');
  
  // Add cover image if available
  if (post.cover) {
    const imgTd = document.createElement('td');
    imgTd.style.cssText = 'padding:20px;width:25%;vertical-align:middle';
    
    const coverLink = document.createElement('a');
    coverLink.href = post.url;
    
    if (post.cover.endsWith('.mov') || post.cover.endsWith('.mp4')) {
      // Handle video covers
      const video = document.createElement('video');
      video.style.cssText = 'width:100%;max-width:200px;height:120px;object-fit:cover;border-radius:8px;';
      video.autoplay = true;
      video.loop = true;
      video.muted = true;
      video.src = post.cover;
      coverLink.appendChild(video);
    } else {
      // Handle image covers
      const img = document.createElement('img');
      img.style.cssText = 'width:100%;max-width:200px;height:120px;object-fit:cover;border-radius:8px;';
      img.src = post.cover;
      img.alt = post.title;
      coverLink.appendChild(img);
    }
    
    imgTd.appendChild(coverLink);
    tr.appendChild(imgTd);
  }
  
  const td = document.createElement('td');
  td.style.cssText = 'padding:20px;width:' + (post.cover ? '75%' : '100%') + ';vertical-align:middle';
  
  // Title
  const heading = document.createElement('heading');
  heading.textContent = post.title;
  td.appendChild(heading);
  
  // Date and read time
  const datePara = document.createElement('p');
  const dateEm = document.createElement('em');
  dateEm.textContent = post.date;
  if (post.readTime) {
    dateEm.textContent += ' · ' + post.readTime + ' read';
  }
  datePara.appendChild(dateEm);
  td.appendChild(datePara);
  
  // Excerpt
  const excerptPara = document.createElement('p');
  excerptPara.innerHTML = post.excerpt + ' <a href="' + post.url + '">Read more →</a>';
  td.appendChild(excerptPara);
  
  tr.appendChild(td);
  tbody.appendChild(tr);
  table.appendChild(tbody);
  
  return table;
}

// Load blog posts
function loadBlogPosts(category = 'all') {
  const container = document.getElementById('blog-posts-list');
  if (!container || typeof blogPosts === 'undefined') return;
  
  container.innerHTML = '';
  
  const posts = getBlogPostsByCategory(category);
  
  posts.forEach(post => {
    const postElement = createBlogPost(post);
    container.appendChild(postElement);
  });
}

// Add blog category filters
function addBlogCategories() {
  const container = document.getElementById('blog-categories');
  if (!container || typeof blogCategories === 'undefined') return;
  
  const links = blogCategories.map(cat => {
    const isActive = cat.value === currentBlogCategory;
    const style = isActive ? 'font-weight:700;' : '';
    return '<a href="javascript:;" onclick="filterBlogPosts(\'' + cat.value + '\')" style="' + style + '">' + cat.label + '</a>';
  });
  
  container.innerHTML = 'Filter: ' + links.join(' | ');
}

// Filter blog posts by category
function filterBlogPosts(category) {
  currentBlogCategory = category;
  addBlogCategories();
  loadBlogPosts(category);
}

// Filter by year
function filterByYear(year) {
  const container = document.getElementById('blog-posts-list');
  if (!container || typeof blogPosts === 'undefined') return;
  
  container.innerHTML = '';
  
  const posts = getBlogPostsByYear(year);
  
  posts.forEach(post => {
    const postElement = createBlogPost(post);
    container.appendChild(postElement);
  });
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
  // Load publications based on page
  if (document.getElementById('selected-publications')) {
    loadSelectedPublications();
  }
  
  if (document.getElementById('publications-table')) {
    addFilterButtons();
    loadPublications(currentFilter);
  }
  
  // Load projects if on projects page
  if (document.getElementById('projects-table')) {
    loadProjects();
  }
  
  // Load featured projects if element exists
  if (document.getElementById('featured-projects')) {
    loadFeaturedProjects();
  }
  
  // Load blog posts if on blog page
  if (document.getElementById('blog-posts-list')) {
    addBlogCategories();
    loadBlogPosts(currentBlogCategory);
  }
  
  // Add smooth scroll behavior
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });
  
  // Close modal on ESC key
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      closeBibTeX();
    }
  });
});