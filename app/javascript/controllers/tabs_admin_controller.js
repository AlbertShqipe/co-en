import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs-admin"
export default class extends Controller {
  static targets= ["link", "tab"]

  connect() {
    this.linkTargets.forEach(link => {
      link.addEventListener('click', (event) => {
      this.linkTargets.forEach(link => link.classList.remove('active'));
      link.classList.add('active');
      });
    })
    this.tabTargets.forEach(tab => {
      if (tab.dataset.tabsTypeValue === this.defaultValue) {
        tab.classList.add('hidden');
      }
    });
  }

  open(event) {
    event.preventDefault
    let tabId = event.currentTarget.dataset.id
    this.tabTargets.forEach(tab => {
      if (tab.dataset.tabsAdminTypeValue !== tabId)
        tab.classList.add('hidden')
      else
        tab.classList.remove('hidden')
    });
  }
}
