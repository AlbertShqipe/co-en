import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="participant"
export default class extends Controller {
    connect() {

    const addParticipantButton = document.getElementById('add-participant');
    const participantsContainer = document.getElementById('participants');
    const participantTemplate = document.getElementById('participant-template').innerHTML;
    const participants = document.getElementById('participants').querySelectorAll('.participant-fields');

    for (let index = 0; index < participants.length; index++) {
      const suffix = index === 0 ? "" : index; // No suffix for the first participant

      // Add event listener for photo input
      document.getElementById(`photo-input${suffix}`).addEventListener("change", function() {
        const photoName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById(`photo-name${suffix}`).textContent = photoName;
        console.log(photoName);
      });

      // Add event listener for file input
      document.getElementById(`file-input${suffix}`).addEventListener("change", function() {
        const fileName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById(`file-name${suffix}`).textContent = fileName;
        console.log(fileName);
      });

      // Add event listener for ID card input
      document.getElementById(`id-input${suffix}`).addEventListener("change", function() {
        const idName = this.files[0] ? this.files[0].name : "No file selected";
        document.getElementById(`id-name${suffix}`).textContent = idName;
        console.log(idName);
      });
    }

    // let participantIndex = document.querySelectorAll('.participant-fields').length;
    if (addParticipantButton) {
      addParticipantButton.addEventListener('click', (event) => {
        event.preventDefault();
        let participantIndex = document.querySelectorAll('.participant-fields').length;
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
        });
        document.getElementById(`id-input${participantIndex}`).addEventListener("change", function() {
          const idName = this.files[0] ? this.files[0].name : "No file selected";
          document.getElementById(`id-name${participantIndex}`).textContent = idName;
          console.log(idName);
        });
        console.log(participantIndex);
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
