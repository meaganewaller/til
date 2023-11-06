document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('til').addEventListener('click', function() {
    confetti({
      particleCount: 150,
      spread: 100,
      origin: {
        y: 0.80,
      },
    });
  });
});
