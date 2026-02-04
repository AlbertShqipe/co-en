import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="swiper"
export default class extends Controller {
  connect() {
    if (typeof Swiper === "undefined") {
      console.warn("Swiper is not loaded.");
      return;
    }

    // Check if it's a studio carousel or a review carousel
    if (this.element.classList.contains("carousel")) {
      new Swiper(this.element, {
        loop: true,
        slidesPerView: 1,
        spaceBetween: 10,
        speed: 1000,
        autoplay: {
          delay: 3000,
          disableOnInteraction: false,
        },
        navigation: {
          nextEl: this.element.querySelector(".swiper-button-next"),
          prevEl: this.element.querySelector(".swiper-button-prev")
        },
        pagination: {
          el: this.element.querySelector(".swiper-pagination"),
          clickable: true,
        }
      });
    }
  }
}
