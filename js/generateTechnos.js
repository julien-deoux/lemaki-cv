const generateTechnos = (function (){
  function generateTechno(techno) {
    const tag = document.createElement('div');
    tag.classList.add('techno');

    tag.innerHTML = `
      <span class="techno__icon"><img src="${techno.icon}" /></span>
      <span class="techno__name">${techno.name}</span>
    `;

    return tag;
  }

  return function() {
    const xhr = new XMLHttpRequest();
    xhr.addEventListener('load', handler);
    xhr.open('GET', `content/technos.json`);
    xhr.send();

    function handler() {
      const tag = document.getElementById('technos');
      const technos = JSON.parse(this.responseText);

      technos.forEach(techno => {
        tag.append(generateTechno(techno))
      });
    }
  }
})();
