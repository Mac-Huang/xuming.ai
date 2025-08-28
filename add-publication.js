#!/usr/bin/env node

// Simple Node.js script to add new publications to publications.js
// Usage: node add-publication.js

const fs = require('fs');
const path = require('path');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Helper function to ask questions
const question = (prompt) => {
  return new Promise((resolve) => {
    rl.question(prompt, (answer) => {
      resolve(answer);
    });
  });
};

// Format authors with bold tags for Xuming Huang
function formatAuthors(authors) {
  return authors.split(',').map(author => {
    const trimmed = author.trim();
    if (trimmed.toLowerCase().includes('xuming huang')) {
      return '<strong>Xuming Huang</strong>';
    }
    return trimmed;
  }).join(', ');
}

// Generate publication ID from title and year
function generateId(title, year) {
  const words = title.toLowerCase()
    .replace(/[^a-z0-9\s]/g, '')
    .split(' ')
    .filter(w => w.length > 3)
    .slice(0, 2);
  return words.join('-') + '-' + year;
}

// Main function to add publication
async function addPublication() {
  console.log('\n=== Add New Publication ===\n');
  
  // Gather publication information
  const title = await question('Title: ');
  const authorsRaw = await question('Authors (comma-separated, your name will be auto-bolded): ');
  const venue = await question('Venue (e.g., "Conference on Machine Learning Systems (MLSys)"): ');
  const year = await question('Year: ');
  const category = await question('Category (conference/journal/preprint): ') || 'conference';
  const selected = (await question('Is this a selected/featured publication? (y/n): ')).toLowerCase() === 'y';
  
  // Optional fields
  const paperUrl = await question('Paper URL (arXiv or conference link, press Enter to skip): ') || null;
  const codeUrl = await question('Code URL (GitHub link, press Enter to skip): ') || null;
  const projectUrl = await question('Project URL (press Enter to skip): ') || null;
  const abstract = await question('Abstract/Description (press Enter to skip): ') || '';
  
  // BibTeX
  console.log('\nEnter BibTeX (paste multiple lines, type END on a new line when done):');
  let bibtex = '';
  let line;
  while ((line = await question('')) !== 'END') {
    bibtex += line + '\n';
  }
  bibtex = bibtex.trim() || null;
  
  // Image
  const imageFile = await question('Image filename (e.g., "paper-name.jpg", press Enter to skip): ');
  const image = imageFile ? `images/papers/${imageFile}` : `images/papers/${generateId(title, year)}.jpg`;
  
  // Create publication object
  const publication = {
    id: generateId(title, year),
    title: title,
    authors: formatAuthors(authorsRaw),
    venue: venue,
    year: parseInt(year),
    image: image,
    paper_url: paperUrl,
    code_url: codeUrl,
    project_url: projectUrl,
    bibtex: bibtex,
    selected: selected,
    category: category,
    abstract: abstract
  };
  
  // Display the publication
  console.log('\n=== New Publication ===');
  console.log(JSON.stringify(publication, null, 2));
  
  const confirm = await question('\nAdd this publication? (y/n): ');
  
  if (confirm.toLowerCase() === 'y') {
    // Read existing publications file
    const filePath = path.join(__dirname, 'data', 'publications.js');
    let fileContent = fs.readFileSync(filePath, 'utf8');
    
    // Find the publications array
    const arrayStart = fileContent.indexOf('const publications = [');
    const arrayEnd = fileContent.lastIndexOf('];');
    
    if (arrayStart === -1 || arrayEnd === -1) {
      console.error('Error: Could not find publications array in file');
      process.exit(1);
    }
    
    // Format the new publication entry
    const publicationEntry = `  {
    id: '${publication.id}',
    title: '${publication.title.replace(/'/g, "\\'")}',
    authors: '${publication.authors}',
    venue: '${publication.venue.replace(/'/g, "\\'")}',
    year: ${publication.year},
    image: '${publication.image}',
    paper_url: ${publication.paper_url ? "'" + publication.paper_url + "'" : 'null'},
    code_url: ${publication.code_url ? "'" + publication.code_url + "'" : 'null'},
    project_url: ${publication.project_url ? "'" + publication.project_url + "'" : 'null'},
    bibtex: ${publication.bibtex ? '`' + publication.bibtex + '`' : 'null'},
    selected: ${publication.selected},
    category: '${publication.category}',
    abstract: '${publication.abstract.replace(/'/g, "\\'")}'
  }`;
    
    // Insert the new publication at the beginning of the array
    const beforeArray = fileContent.substring(0, arrayStart + 'const publications = ['.length);
    const afterArray = fileContent.substring(arrayStart + 'const publications = ['.length);
    
    // Check if we need to add a comma after the new entry
    const needsComma = afterArray.trim().startsWith('\n  {');
    
    fileContent = beforeArray + '\n' + publicationEntry + (needsComma ? ',' : '') + afterArray;
    
    // Write back to file
    fs.writeFileSync(filePath, fileContent);
    
    console.log('\n✅ Publication added successfully!');
    console.log(`📁 Don't forget to add the thumbnail image at: ${publication.image}`);
    
    // Create thumbnail placeholder if it doesn't exist
    const imagePath = path.join(__dirname, publication.image);
    const imageDir = path.dirname(imagePath);
    
    if (!fs.existsSync(imageDir)) {
      fs.mkdirSync(imageDir, { recursive: true });
    }
    
    if (!fs.existsSync(imagePath) && !imageFile) {
      console.log('💡 Tip: Add a 160px wide thumbnail image for best results');
    }
  } else {
    console.log('\nPublication not added.');
  }
  
  rl.close();
}

// Run the script
addPublication().catch(console.error);