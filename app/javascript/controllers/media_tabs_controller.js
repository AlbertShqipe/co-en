import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="media-tabs"
export default class extends Controller {
  static targets = ["link", "tab"]
  static values = { default: String }

  connect() {
    this.linkTargets.forEach(link => {
      link.addEventListener('click', (event) => {
        this.linkTargets.forEach(link => link.classList.remove('active'));
        link.classList.add('active');

      });
    })
    this.tabTargets.forEach(tab => {
      if (tab.dataset.values === this.defaultValue) {
        tab.classList.remove('hidden');
      }
    });
  }

  open(event) {
    event.preventDefault()
    let tabId = event.currentTarget.dataset.id
    this.tabTargets.forEach(tab => {
      if (tab.dataset.mediaTabsTypeValue !== tabId)
        tab.classList.add('hidden')
      else
        tab.classList.remove('hidden')
    });
  }
}
