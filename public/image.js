document.addEventListener('DOMContentLoaded', () => {
  const slides = document.querySelectorAll('.slide');
  let current = 0;

  setInterval(() => {
    slides[current].classList.remove('active');

    current = (current + 1) % slides.length;

    slides[current].classList.add('active');
  }, 3000); // κάθε 3 δευτερόλεπτα
});