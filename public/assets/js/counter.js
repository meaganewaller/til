document.addEventListener('DOMContentLoaded', () => {
  let onCooldown = false;

  function startCooldown() {
    if (!onCooldown) {
      onCooldown = true;
      document.getElementById('til').disabled = true;

      setTimeout(function() {
        onCooldown = false;
        document.getElementById('til').disabled = false;
      }, 5000);
    }
  }

  const counterElement = document.getElementById('counter');
  const buttonElement = document.getElementById('til');

  function incrementCounter() {
    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded')
    xhr.send()

    counterElement.textContent = parseInt(counterElement.textContent) + 1;
    startCooldown();
  }

  buttonElement.addEventListener('click', () => {
    if (onCooldown) {
      return;
    }

    incrementCounter();
  });
})
