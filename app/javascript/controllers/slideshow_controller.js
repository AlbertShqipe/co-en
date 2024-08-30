import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="slideshow"
export default class extends Controller {
  static targets = ["slide"];

  // Default index for the initial slide
  static values = {
    initialIndex: 12
  };

  connect() {
    this.slideIndex = this.initialIndexValue || 1; // Default to 1 if no initial index is provided
    this.showSlide(this.slideIndex); // Show the initial slide
    this.timeout = setTimeout(this.showSlides.bind(this), 5000); // Start the automatic slideshow
  }

  showSlides() {
    const slides = this.slideTargets;
    slides.forEach((slide, index) => {
      slide.style.display = "none";
    });

    this.slideIndex++;
    if (this.slideIndex > slides.length) {
      this.slideIndex = 1;
    }
    slides[this.slideIndex - 1].style.display = "block";

    this.timeout = setTimeout(this.showSlides.bind(this), 5000); // Change image every 5 seconds
  }

  selectSlide(event) {
    clearTimeout(this.timeout); // Stop the automatic slideshow

    const index = parseInt(event.currentTarget.querySelector('img').dataset.index, 10);
    this.slideIndex = index;
    this.showSlide(this.slideIndex);
  }

  showSlide(index) {
    const slides = this.slideTargets;
    slides.forEach((slide) => {
      slide.style.display = "none";
    });

    slides[index - 1].style.display = "block";
  }
}

// Set initial index as a value attribute
document.addEventListener("DOMContentLoaded", () => {
  const slideshowController = document.querySelector("[data-controller='slideshow']").controller;
  if (slideshowController) {
    slideshowController.initialIndexValue = 1; // Set this to any index you want to start with
  }
});
