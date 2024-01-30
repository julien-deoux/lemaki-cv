const generateTechnos = (function (){
  function generateTechno(techno) {
    const tag = document.createElement('div');
    tag.classList.add('techno');

    tag.innerHTML = `
      <img class="techno__icon" src="${techno.icon}" />
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
