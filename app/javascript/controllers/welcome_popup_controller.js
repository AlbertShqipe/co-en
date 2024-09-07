import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="welcome-popup"
export default class extends Controller {
  static targets = ["popup"];

  connect() {
    if (!sessionStorage.getItem('popupDismissed')) {
      this.showPopup();
    }
  }

  showPopup() {
    this.popupTarget.style.display = 'flex';
  }

  dismissPopup() {
    this.popupTarget.style.display = 'none';
    sessionStorage.setItem('popupDismissed', true);
    this.dismissPopupOnServer();
  }

  dismissPopupOnServer() {
    fetch('/dismiss_welcome_popup', {
      method: 'GET',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
      }
    });
  }
}
