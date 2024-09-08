import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="participant"
export default class extends Controller {
    connect() {

    const addParticipantButton = document.getElementById('add-participant');
    const participantsContainer = document.getElementById('participants');
    const participantTemplate = document.getElementById('participant-template').innerHTML;

    let participantIndex = document.querySelectorAll('.participant-fields').length;

    if (addParticipantButton) {
      addParticipantButton.addEventListener('click', (event) => {
        event.preventDefault();

        const newParticipant = participantTemplate.replace(/NEW_RECORD/g, participantIndex);
        participantsContainer.insertAdjacentHTML('beforeend', newParticipant);
        participantIndex++;
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
