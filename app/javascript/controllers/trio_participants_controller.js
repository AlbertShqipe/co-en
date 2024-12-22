import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="trio-participants"
export default class extends Controller {
  connect() {
    const photoInput = document.getElementById("photo-input");
    const fileInput = document.getElementById("file-input");
    const idInput = document.getElementById("id-input");

    if (photoInput) {
      photoInput.addEventListener("change", function() {
        const photoName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById("photo-name").textContent = photoName;
      });
    }
    if (fileInput) {
      fileInput.addEventListener("change", function() {
        const fileName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById("file-name").textContent = fileName;
      });
    }
    if (idInput) {
      idInput.addEventListener("change", function() {
        const idName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById("id-name").textContent = idName;
      });
    }

    const photoInput1 = document.getElementById("photo-input1");
    const fileInput1 = document.getElementById("file-input1");
    const idInput1 = document.getElementById("id-input1");
    if (photoInput1) {
      photoInput1.addEventListener("change", function() {
        const photoName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById("photo-name1").textContent = photoName;
      });
    }
    if (fileInput1) {
      fileInput1.addEventListener("change", function() {
        const fileName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById("file-name1").textContent = fileName;
      });
    }
    if (idInput1) {
      idInput1.addEventListener("change", function() {
        const idName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById("id-name1").textContent = idName;
      });
    }

    const photoInput2 = document.getElementById("photo-input2");
    const fileInput2 = document.getElementById("file-input2");
    const idInput2 = document.getElementById("id-input2");
    if (photoInput2) {
      photoInput2.addEventListener("change", function() {
        const photoName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById("photo-name2").textContent = photoName;
      });
    }
    if (fileInput2) {
      fileInput2.addEventListener("change", function() {
        const fileName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById("file-name2").textContent = fileName;
      });
    }
    if (idInput2){
      idInput2.addEventListener("change", function() {
        const idName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById("id-name2").textContent = idName;
      });
    }
  }
}
