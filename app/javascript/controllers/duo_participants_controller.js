import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="duo-participants"
export default class extends Controller {
  connect() {
    document.getElementById("photo-input").addEventListener("change", function() {
      const photoName = this.files[0] ? this.files[0].name : "No file selected";
      document.getElementById("photo-name").textContent = photoName;
    });
    document.getElementById("file-input").addEventListener("change", function() {
      const fileName = this.files[0] ? this.files[0].name : "No file selected";
      document.getElementById("file-name").textContent = fileName;
    });
    document.getElementById("photo-input1").addEventListener("change", function() {
      const photoName = this.files[0] ? this.files[0].name : "No file selected";
      document.getElementById("photo-name1").textContent = photoName;
    });
    document.getElementById("file-input1").addEventListener("change", function() {
      const fileName = this.files[0] ? this.files[0].name : "No file selected";
      document.getElementById("file-name1").textContent = fileName;
    });
  }
}
