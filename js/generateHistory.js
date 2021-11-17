const generateHistory = (function () {
  function period(startDate, endDate, locale) {
    const formatDate = (date) => date.toLocaleDateString(locale, {
      month: 'short',
      year: 'numeric'
    });

    return `${formatDate(startDate)} - ${formatDate(endDate)}`;
  }

  function generateJob(job, locale) {
    const tag = document.createElement('div');
    tag.classList.add('job');

    tag.innerHTML = `
      <div class="job__period">${period(job.startDate, job.endDate, locale)}</div>
      <div class="job__structure">${job.name}</div>
      <div class="job__title">${job.position}</div>
    ` + (job.summary ?
        `
        <div class="job__details">
          ${job.summary}
        </div>
      `
        : '');

    return tag;
  }

  return function (locale) {
    const xhr = new XMLHttpRequest();
    xhr.addEventListener('load', handler);
    xhr.open('GET', `content/history.json`);
    xhr.send();

    function handler() {
      const tag = document.getElementById('history');
      const history = JSON.parse(
        this.responseText,
        (key, value) => ('endDate' === key || 'startDate' === key) ? new Date(value)
          : ('position' === key || 'summary' === key) ? value[locale]
          : value
      );

      console.log(history);

      history.forEach(job => {
        tag.append(generateJob(job, locale))
      });
    }
  }
})();
