import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ind-candidate"
export default class extends Controller {
  connect() {
    const photoName = document.getElementById(`photo-input`);
    const fileName = document.getElementById(`file-input`);
    const idName = document.getElementById(`id-input`);

    if (photoName) {
      document.getElementById(`photo-input`).addEventListener("change", function() {
        const photoName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById(`photo-name`).textContent = photoName;
        console.log(photoName);
      });
    }

    if (fileName) {
      document.getElementById(`file-input`).addEventListener("change", function() {
        const fileName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById(`file-name`).textContent = fileName;
        console.log(fileName);
      });
    }

    if (idName) {
      document.getElementById(`id-input`).addEventListener("change", function() {
        const idName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById(`id-name`).textContent = idName;
        console.log(idName);
      });
    }
  }
}
