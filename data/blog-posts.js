// Blog posts data - simple and clean
const blogPosts = [
  {
    id: 'linuxguard-journey',
    title: 'My Journey with LinuxGuard',
    date: 'November 19, 2025',
    category: 'education',
    excerpt: 'Reflecting on 6 months of research: building LLM-driven kernel checkers, learning from Vinay Banakar, and the hard reality of being scooped by SOSP.',
    url: 'blog/posts/linuxguard-journey.html',
    readTime: '6 min',
    cover: 'images/papers/LinuxGuard_Cover.jpg'
  },

  {
    id: 'stanford-summer',
    title: 'Stanford Summer: Where Systems Meet Algorithms',
    date: 'August 15, 2025',
    category: 'education',
    excerpt: 'My transformative summer at Stanford taking CS107 (A+, 99/100) and CS161 (A, 93/100). From heap allocators to algorithm analysis, discovering security vulnerabilities, and learning from amazing instructors.',
    url: 'blog/posts/stanford-summer-2025.html',
    readTime: '10 min',
    cover: 'images/blog/Stanford-Cover.jpg'
  },

  {
    id: 'new-chapter-madison',
    title: 'A New Chapter in Madison',
    date: 'January 16, 2025',
    category: 'life',
    excerpt: "My first experiences in the United States, specifically in Madison, Wisconsin. It's a mix of culture shock, new friendships, and personal growth.",
    url: 'blog/posts/new-chapter-madison.html',
    readTime: '4 min',
    cover: 'images/blog/Madison_Cover.jpg'
  },

  {
    id: 'first-internship',
    title: 'Diving into AI: My Transformative First Week at CoolAI',
    date: 'July 9, 2024',
    category: 'career',
    excerpt: 'My internship experience at CoolAI, developing AI products and representing the company at the World Artificial Intelligence Conference (WAIC).',
    url: 'blog/posts/first-internship.html',
    readTime: '5 min',
    cover: 'images/blog/CoolAI.jpg'
  },

  {
    id: 'hello-world',
    title: 'Hello World',
    date: 'June 5, 2024',
    category: 'life',
    excerpt: "Welcome to my first-ever website and blog post! Right here, I'm gonna jot down significant milestones in my life.",
    url: 'blog/posts/hello-world.html',
    readTime: '2 min',
    cover: 'images/blog/HelloWorld-Cover.jpg'
  },

  {
    id: 'nfl-flag-football',
    title: 'Champions Unleashed: USST Earthmoving Vehicles Triumph!',
    date: 'December 8, 2023',
    category: 'sports',
    excerpt: 'Celebrating our 2023 NFL FLAG "Star of Shine" National Championship victory - a pinnacle in our 14-year saga of sheer grit and dominance.',
    url: 'blog/posts/nfl-flag-football-championship.html',
    readTime: '3 min',
    cover: 'images/blog/Football-Cover.jpg'
  }
];

// Helper functions
function getBlogPostsByCategory(category) {
  if (category === 'all') return blogPosts;
  return blogPosts.filter(post => post.category === category);
}

function getBlogPostsByYear(year) {
  return blogPosts.filter(post => new Date(post.date).getFullYear() === year);
}

function getRecentPosts(limit = 5) {
  return blogPosts.slice(0, limit);
}

// Blog categories - simplified
const blogCategories = [
  { label: 'All', value: 'all' },
  { label: 'Academic', value: 'education' },
  { label: 'Life', value: 'life' },
  { label: 'Career', value: 'career' }
];
