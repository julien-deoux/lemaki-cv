const generateSkills = (function(){
  marked.use({
    renderer: {
      paragraph(text) {
        return `<p class="main__paragraph">${text}</p>`;
      },
      heading(text, level) {
        return `<h${level} class="main__title">${text}</h${level}>`
      }
    }
  });

  function generateCategory(locale, category) {
    const tag = document.getElementById(category);

    function handler() {
      const text = this.responseText;
      tag.innerHTML = marked(text);
    }

    const xhr = new XMLHttpRequest();
    xhr.addEventListener('load', handler);
    xhr.open('GET', `skills/${locale}/${category}.md`);
    xhr.send();
  }

  const categories = [ 'front-end', 'back-end' , 'misc' ];

  return function(locale) {
    categories.forEach(category => generateCategory(locale, category));
  };
})();
