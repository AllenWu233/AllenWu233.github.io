// Add a copy button (labelled with the language) to each code block.
(function () {
  'use strict';

  function copy(text, done) {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(text).then(done, done);
    } else {
      var ta = document.createElement('textarea');
      ta.value = text;
      ta.style.position = 'fixed';
      ta.style.opacity = '0';
      document.body.appendChild(ta);
      ta.select();
      try { document.execCommand('copy'); } catch (e) {}
      document.body.removeChild(ta);
      done();
    }
  }

  document.querySelectorAll('div.highlight').forEach(function (block) {
    var code = block.querySelector('pre code');
    if (!code) return;
    var lang = code.getAttribute('data-lang') || 'code';

    var btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'code-copy';
    btn.textContent = lang;
    btn.setAttribute('aria-label', 'Copy code');

    btn.addEventListener('click', function () {
      var text = code.textContent.replace(/\n$/, '');
      copy(text, function () {
        btn.textContent = 'copied!';
        setTimeout(function () { btn.textContent = lang; }, 1500);
      });
    });

    block.appendChild(btn);
  });
})();
