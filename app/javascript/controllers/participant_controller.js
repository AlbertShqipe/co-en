import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="participant"
export default class extends Controller {
    connect() {

    const addParticipantButton = document.getElementById('add-participant');
    const participantsContainer = document.getElementById('participants');
    const participantTemplate = document.getElementById('participant-template').innerHTML;
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

    let participantIndex = document.querySelectorAll('.participant-fields').length;
    if (addParticipantButton) {
      addParticipantButton.addEventListener('click', (event) => {
        event.preventDefault();
        const newParticipant = participantTemplate.replace(/NEW_RECORD/g, participantIndex);
        participantsContainer.insertAdjacentHTML('beforeend', newParticipant);
        document.getElementById(`photo-input${participantIndex}`).addEventListener("change", function() {
          const photoName = this.files[0] ? this.files[0].name : "No file selected";
          document.getElementById(`photo-name${participantIndex}`).textContent = photoName;
          console.log(photoName);
        });
        document.getElementById(`file-input${participantIndex}`).addEventListener("change", function() {
          const fileName = this.files[0] ? this.files[0].name : "No file selected";
          document.getElementById(`file-name${participantIndex}`).textContent = fileName;
          console.log(fileName);
        participantIndex++;
        });
      });
    }

    // Add event listener for the remove buttons
    participantsContainer.addEventListener('click', (event) => {
      if (event.target.classList.contains('remove-participant')) {
        event.preventDefault();
        const participantField = event.target.closest('.participant-fields');
        if (participantField) {
          participantField.remove();
        }
      }
    });
  }
}
