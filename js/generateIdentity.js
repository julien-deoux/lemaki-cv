const generateIdentity = (function () {
  function generateContact(contact) {
    const tag = document.createElement('li');
    tag.classList.add('contact');


    tag.innerHTML = `
      <span class="${contact.classes} contact__icon"></span>
    ` + (
        contact.link ? `
        <a class="contact__name" href="${contact.link}">
          ${contact.text}
        </a>
      ` : `
        <span class="contact__name">
          ${contact.text}
        </span>
      `
      );

    return tag;
  }

  function contactList(contactObject) {
    const co = contactObject;
    let result = [];
    if (co.phone) {
      result.push({ classes: 'fas fa-phone', text: co.phone });
    }
    if (co.email) {
      result.push({ classes: 'fas fa-envelope', text: co.email, link: 'mailto:' + co.email });
    }
    if (co.website) {
      result.push({ classes: 'fas fa-cloud', text: co.website, link: 'https://' + co.website });
    }
    if (co.linkedin) {
      result.push({ classes: 'fab fa-linkedin', text: 'linkedin.com/in/' + co.linkedin, link: 'https://linkedin.com/in/' + co.linkedin });
    }
    if (co.github) {
      result.push({ classes: 'fab fa-github', text: 'github.com/' + co.github, link: 'https://github.com/' + co.github });
    }
    return result;
  }

  function generateContacts(identity) {
    const tag = document.getElementById('contacts');
    contactList(identity).forEach(contact => {
      tag.append(generateContact(contact))
    });
  }

  function generateName(identity) {
    const tag = document.getElementById('name');
    tag.innerText = identity.name;
  }

  return function () {
    const xhr = new XMLHttpRequest();
    xhr.addEventListener('load', handler);
    xhr.open('GET', `content/identity.json`);
    xhr.send();

    function handler() {
      const identity = JSON.parse(this.responseText);

      generateContacts(identity);
      generateName(identity)
    }
  }
})();
