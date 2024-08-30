import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="age"
export default class extends Controller {
  connect() {
    // Find the elements within the connected element's context
    const ageInput = this.element.querySelector('#age-input');
    const ageOutput = this.element.querySelector('#myID');


    // Check if both elements are found before adding event listeners
    if (ageInput && ageOutput) {
      ageOutput.addEventListener('change', () => {
        console.log("date changed")
        const birthday = ageOutput.value;
        if (birthday) {
          const age = this.calculateAge(birthday);
          ageInput.value = age;
        } else {
          ageInput.value = ""; // Clear the age input if no birthday is selected
        }
      });
    } else {
      console.error("Element not found: Make sure #age-input and #myID exist in the DOM.");
    }
  }

  calculateAge(birthdate) {
    const birthday = new Date(birthdate);
    const today = new Date();
    let age = today.getFullYear() - birthday.getFullYear();
    const monthDiff = today.getMonth() - birthday.getMonth();

    // Adjust age if the birthdate hasn't occurred yet this year
    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthday.getDate())) {
      age--;
    }

    return age;
  }
}
