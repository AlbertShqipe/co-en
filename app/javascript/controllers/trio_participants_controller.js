import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="trio-participants"
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
    document.getElementById("id-input").addEventListener("change", function() {
      const idName = this.files[0] ? this.files[0].name : "No file selected";
      document.getElementById("id-name").textContent = idName;
    });

    document.getElementById("photo-input1").addEventListener("change", function() {
      const photoName = this.files[0] ? this.files[0].name : "No file selected";
      document.getElementById("photo-name1").textContent = photoName;
    });
    document.getElementById("file-input1").addEventListener("change", function() {
      const fileName = this.files[0] ? this.files[0].name : "No file selected";
      document.getElementById("file-name1").textContent = fileName;
    });
    document.getElementById("id-input1").addEventListener("change", function() {
      const idName = this.files[0] ? this.files[0].name : "No file selected";
      document.getElementById("id-name1").textContent = idName;
    });

    document.getElementById("photo-input2").addEventListener("change", function() {
      const photoName = this.files[0] ? this.files[0].name : "No file selected";
      document.getElementById("photo-name2").textContent = photoName;
    });
    document.getElementById("file-input2").addEventListener("change", function() {
      const fileName = this.files[0] ? this.files[0].name : "No file selected";
      document.getElementById("file-name2").textContent = fileName;
    });
    document.getElementById("id-input2").addEventListener("change", function() {
      const idName = this.files[0] ? this.files[0].name : "No file selected";
      document.getElementById("id-name2").textContent = idName;
    });
  }
}
