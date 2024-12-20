import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="duo-participants"
export default class extends Controller {
  connect() {
    const photoInput = document.getElementById("photo-input");
    const fileInput = document.getElementById("file-input");
    const idInput = document.getElementById("id-input");

    if (photoInput) {
      document.getElementById("photo-input").addEventListener("change", function() {
        const photoName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById("photo-name").textContent = photoName;
      });
    }
    if (fileInput) {
      document.getElementById("file-input").addEventListener("change", function() {
        const fileName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById("file-name").textContent = fileName;
      });
    }
    if (idInput) {
      document.getElementById("id-input").addEventListener("change", function() {
        const idName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById("id-name").textContent = idName;
      });
    }

    const photoInput1 = document.getElementById("photo-input1");
    const fileInput1 = document.getElementById("file-input1");
    const idInput1 = document.getElementById("id-input1");
    if (photoInput1) {
      document.getElementById("photo-input1").addEventListener("change", function() {
        const photoName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById("photo-name1").textContent = photoName;
      });
    }
    if (fileInput1) {
      document.getElementById("file-input1").addEventListener("change", function() {
        const fileName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById("file-name1").textContent = fileName;
      });
    }
    if (idInput1) {
      document.getElementById("id-input1").addEventListener("change", function() {
        const idName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById("id-name1").textContent = idName;
      });
    }
  }
}
