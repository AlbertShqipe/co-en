import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="flatpickr"
export default class extends Controller {
  connect() {
    console.log("Connected", this.element);
    this.initializeFlatpickr();

    // Set up the mutation observer
    this.observer = new MutationObserver(this.initializeFlatpickr);
    const config = { childList: true, subtree: true };
    this.observer.observe(document.body, config);
  }

  disconnect() {
    // Disconnect the mutation observer when the controller is disconnected
    if (this.observer) {
      this.observer.disconnect();
    }
  }

  initializeFlatpickr = () => {
    document.querySelectorAll("#myID").forEach((element) => {
      // Initialize flatpickr if it hasn't been initialized yet
      if (!element._flatpickr) {
        flatpickr(element, {
          // Flatpickr options here
        });
      }
    });
  }
}
