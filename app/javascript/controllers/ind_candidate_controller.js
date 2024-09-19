import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ind-candidate"
export default class extends Controller {
  connect() {
    document.getElementById(`photo-input`).addEventListener("change", function() {
      const photoName = this.files[0] ? this.files[0].name : "No file selected";
      document.getElementById(`photo-name`).textContent = photoName;
      console.log(photoName);
    });
    document.getElementById(`file-input`).addEventListener("change", function() {
      const fileName = this.files[0] ? this.files[0].name : "No file selected";
      document.getElementById(`file-name`).textContent = fileName;
      console.log(fileName);
    });
    document.getElementById(`file1-input`).addEventListener("change", function() {
      const file1Name = this.files[0] ? this.files[0].name : "No file selected";
      document.getElementById(`file1-name`).textContent = file1Name;
      console.log(file1Name);
    });
  }
}
