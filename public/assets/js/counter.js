document.addEventListener('DOMContentLoaded', () => {
  const counterElement = document.getElementById('counter');
  const buttonElement = document.getElementById('til');

  function incrementCounter() {
    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded')
    xhr.send()

    counterElement.textContent = parseInt(counterElement.textContent) + 1;
  }

  buttonElement.addEventListener('click', () => {
    incrementCounter();
  });
})
