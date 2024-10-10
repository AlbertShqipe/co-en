import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static target = ["groupInfo", "soloInfo" , "duoInfo", "trioInfo", "duoTable"]
  connect() {
    const soloSelect = document.getElementById("solo-select");
    const duoSelect = document.getElementById("duo-select");
    const trioSelect = document.getElementById("trio-select");
    const groupSelect = document.getElementById("group-select");
    const duoTableSelect = document.getElementById("duo-table-select");
    // console.log(groupSelect)
    if (soloSelect) {
      // Set up event listener for changes in the select element
      soloSelect.addEventListener('change', (event) => {
        const selectedSoloId = event.target.value;
        // console.log("Selected Solo ID:", selectedSoloId);
        this.fetchSoloInfo(selectedSoloId);
      });
    }

    if (duoSelect) {
      // Set up event listener for changes in the select element
      duoSelect.addEventListener('change', (event) => {
        const selectedDuoId = event.target.value;
        // console.log("Selected Duo ID:", selectedDuoId);
        this.fetchDuoInfo(selectedDuoId);
      });
    }

    if (trioSelect) {
      // Set up event listener for changes in the select element
      trioSelect.addEventListener('change', (event) => {
        const selectedTrioId = event.target.value;
        // console.log("Selected Trio ID:", selectedTrioId);
        this.fetchTrioInfo(selectedTrioId);
      });
    }

    if (groupSelect) {
      // Set up event listener for changes in the select element
      groupSelect.addEventListener('change', (event) => {
        const selectedGroupId = event.target.value;
        // console.log("Selected Group ID:", selectedGroupId);
        this.fetchGroupInfo(selectedGroupId);
      });
    }

    if (duoTableSelect) {
      // Set up event listener for changes in the select element
      duoTableSelect.addEventListener('change', (event) => {
        const selectedDuoTableId = event.target.value;
        console.log("Selected Duo ID:", selectedDuoTableId);
        this.fetchDuoTable(selectedDuoTableId);
      });
    }
  }

  fetchSoloInfo(selectedSoloId) {
    const soloInfoDiv = document.getElementById("solo-info");

    if (selectedSoloId) {
      // Fetch the solo details using AJAX
      fetch(`/solos/${selectedSoloId}/info`) // Modify this route as necessary
      .then(response => response.json())
      .then(data => {
        const soloData = data.solos_list.find(solo => solo.id === data.id);
        const soloCount = soloData ? soloData.count : 'N/A'; // Use 'N/A' if count is not found
          // console.log("Fetched data:", data);
          console.log(data.id_card)
          // Populate the HTML with the fetched data
          soloInfoDiv.innerHTML = `
            <table border="1" cellpadding="20" class="mx-auto" style="width:500px">
              <tr>
                <th colspan="2">Solo ${soloCount}</th>
              </tr>
              <tr>
                <td colspan="2">Information Solo </td>
              </tr>
              <tr>
                <td colspan="2">
                <a href="https://res-3.cloudinary.com/dsyp2wb4w/image/upload/v1/production/${data.photo}?_a=BACE6GEv" target="_blank">
                  <img src='https://res-3.cloudinary.com/dsyp2wb4w/image/upload/v1/production/${data.photo}?_a=BACE6GEv', width="100px"></td>
                </a>
              </tr>
              <tr>
                <td>Prénom</td>
                <td>${data.name}</td>
              </tr>
              <tr>
                <td>Nom</td>
                <td>${data.last_name}</td>
              </tr>
              <tr>
                <td>Date de naissance</td>
                <td>
                ${calculateAge(data.years)}<br>
                ${data.birth_date}
                </td>
              </tr>
              <tr>
                <td>Address</td>
                <td>${data.address}</td>
              </tr>
              <tr>
                <td>Portable</td>
                <td>${data.phone}</td>
              </tr>
              <tr>
                <td>Email</td>
                <td>${data.email}</td>
              </tr>
              <tr>
                <td>Style</td>
                <td>${data.style}</td>
              </tr>
              <tr>
                <td>Niveau</td>
                <td>${data.level}</td>
              </tr>
              <tr>
                <td>Catégorie</td>
                <td>${data.category}</td>
              </tr>
              <tr>
                <td>École de Danse</td>
                <td>${data.dance_school}</td>
              </tr>
              <tr>
                <td>Professeur.e</td>
                <td>${data.teacher_name}</td>
              </tr>
              <tr>
                <td>Portable Professeur.e</td>
                <td>${data.teacher_phone}</td>
              </tr>
              <tr>
                <td>Professeur.e Email</td>
                <td>${data.teacher_email}</td>
              </tr>
            </table>`.replace(/[;,]/g, "");;

        })
        .catch(error => {
          console.error("Error fetching solo data:", error);
          soloInfoDiv.innerHTML = "<p>Error loading solo information.</p>";
        });
    } else {
      // Reset the solo info content if no solo is selected
      soloInfoDiv.innerHTML = "<p>Please select a solo to view its information.</p>";
    }
  }

  fetchDuoInfo(selectedDuoId) {
    const duoInfoDiv = document.getElementById("duo-info");

    if (selectedDuoId) {
      // Fetch the duo details using AJAX
      fetch(`/duos/${selectedDuoId}/info`) // Modify this route as necessary
        .then(response => response.json())
        .then(data => {
          const duoData = data.duo_lists.find(duo => duo.id === data.id);
          const duoCount = duoData ? duoData.count : 'N/A'; // Use 'N/A' if count is not found
          // console.log("Fetched data:", data);
          // console.log(data.participants);
          // Populate the HTML with the fetched data
          duoInfoDiv.innerHTML = `
            <table border="1" cellpadding="20" class="mx-auto" style="width:500px">
              <tr>
                <th colspan="2">Duo ${duoCount}</th>
              </tr>
              <tr>
                <td colspan="2">Information Duo</td>
              </tr>
              <tr>
                <td>Nom Duo</td>
                <td>${data.name}</td>
              </tr>
              <tr>
                <td>Responsable Duo</td>
                <td>${data.responsable}</td>
              </tr>
              <tr>
                <td>Address Duo</td>
                <td>${data.address}</td>
              </tr>
              <tr>
                <td>Portable Duo</td>
                <td>${data.phone}</td>
              </tr>
              <tr>
                <td>Email Duo</td>
                <td>${data.email}</td>
              </tr>
              <tr>
                <td>Discipline</td>
                <td>${data.discipline}</td>
              </tr>
              <tr>
                <td>Niveau Duo</td>
                <td>${data.level}</td>
              </tr>
              <tr>
                <td>Titre de la musique</td>
                <td>${data.title_of_music}</td>
              </tr>
              <tr>
                <td>Compositeur·trice</td>
                <td>${data.composer}</td>
              </tr>
              <tr>
                <td>Durée de la pièce</td>
                <td>${data.length_of_piece}</td>
              </tr>
              <tr>
                <td>Âge moyen</td>
                <td>${data.average_age} ans</td>
              </tr>
              <tr>
                <td colspan="2"><strong>Participant·e·s.</strong></td>
              </tr>
              ${data.participants.map(participant => `
                <tr>
                  <td colspan="2" style="text-align:center">
                    <a href="https://res-3.cloudinary.com/dsyp2wb4w/image/upload/v1/production/${participant.photo}?_a=BACE6GEv" target="_blank">
                      <img src='https://res-3.cloudinary.com/dsyp2wb4w/image/upload/v1/production/${participant.photo}?_a=BACE6GEv', width="100px">
                    </a><br>
                    <p>${capitalize(participant.name)} ${capitalize(participant.last_name)}, ${participant.age} ans<p>
                  </td>
                </tr>
                <tr border="1">
                  <td>file</td>
                  <td>
                    <a href="https://res-console.cloudinary.com/dsyp2wb4w/media_explorer_thumbnails/${participant.asset_id}/detailed" target="_blank">
                      <img src='https://res-console.cloudinary.com/dsyp2wb4w/media_explorer_thumbnails/${participant.asset_id}/detailed', width="100px">
                    </a>
                  </td>
                </tr>

              `)};
            </table>`.replace(/[;,]/g, "");;
        })
        .catch(error => {
          console.error("Error fetching duo data:", error);
          duoInfoDiv.innerHTML = "<p>Error loading duo information.</p>";
        });
    } else {
      // Reset the duo info content if no duo is selected
      duoInfoDiv.innerHTML = "<p>Please select a duo to view its information.</p>";
    }
  }

  fetchTrioInfo(selectedTrioId) {
    const trioInfoDiv = document.getElementById("trio-info");

    if (selectedTrioId) {
      // Fetch the trio details using AJAX
      fetch(`/trios/${selectedTrioId}/info`) // Modify this route as necessary
        .then(response => response.json())
        .then(data => {
          const trioData = data.trio_lists.find(trio => trio.id === data.id);
          const trioCount = trioData ? trioData.count : 'N/A'; // Use 'N/A' if count is not found
          // console.log("Fetched data:", data);
          // console.log(data.participants);
          // Populate the HTML with the fetched data
          trioInfoDiv.innerHTML = `
            <table border="1" cellpadding="20" class="mx-auto" style="width:500px">
              <tr>
                <th colspan="2">Trio ${trioCount}</th>
              </tr>
              <tr>
                <td colspan="2">Information Trio</td>
              </tr>
              <tr>
                <td>Nom Trio</td>
                <td>${data.name}</td>
              </tr>
              <tr>
                <td>Responsable Trio</td>
                <td>${data.responsable}</td>
              </tr>
              <tr>
                <td>Address Trio</td>
                <td>${data.address}</td>
              </tr>
              <tr>
                <td>Portable Trio</td>
                <td>${data.phone}</td>
              </tr>
              <tr>
                <td>Email Trio</td>
                <td>${data.email}</td>
              </tr>
              <tr>
                <td>Discipline</td>
                <td>${data.discipline}</td>
              </tr>
              <tr>
                <td>Niveau Trio</td>
                <td>${data.level}</td>
              </tr>
              <tr>
                <td>Titre de la musique</td>
                <td>${data.title_of_music}</td>
              </tr>
              <tr>
                <td>Compositeur·trice</td>
                <td>${data.composer}</td>
              </tr>
              <tr>
                <td>Durée de la pièce</td>
                <td>${data.length_of_piece}</td>
              </tr>
              <tr>
                <td>Âge moyen</td>
                <td>${data.average_age} ans</td>
              </tr>
              <tr>
                <td colspan="2"><strong>Participant·e·s.</strong></td>
              </tr>
              ${data.participants.map(participant => `
                <tr>
                <td>
                  <a href="https://res-3.cloudinary.com/dsyp2wb4w/image/upload/v1/production/${participant.photo}?_a=BACE6GEv" target="_blank">
                    <img src='https://res-3.cloudinary.com/dsyp2wb4w/image/upload/v1/production/${participant.photo}?_a=BACE6GEv', width="100px">
                  </a>
                </td>
                <td>${capitalize(participant.name)} ${capitalize(participant.last_name)}, ${participant.age} ans</td>
                </tr>
              `)};
            </table>`.replace(/[;,]/g, "");;
        })
        .catch(error => {
          console.error("Error fetching trio data:", error);
          trioInfoDiv.innerHTML = "<p>Error loading trio information.</p>";
        });
    } else {
      // Reset the trio info content if no trio is selected
      trioInfoDiv.innerHTML = "<p>Please select a trio to view its information.</p>";
    }
  }

  fetchGroupInfo(selectedGroupId) {
    const groupInfoDiv = document.getElementById("group-info");

    if (selectedGroupId) {
      // Fetch the group details using AJAX
      fetch(`/group_forms/${selectedGroupId}/info`) // Modify this route as necessary
        .then(response => response.json())
        .then(data => {
          const groupData = data.group_lists.find(group => group.id === data.id);
          const groupCount = groupData ? groupData.count : 'N/A'; // Use 'N/A' if count is not found
          // console.log("Fetched data:", data);
          // console.log(data.participants);
          // Populate the HTML with the fetched data
          console.log(groupCount);
          groupInfoDiv.innerHTML = `
            <table border="1" cellpadding="20" class="mx-auto" style="width:500px">
              <tr>
                <th colspan="2">Group ${groupCount}</th>
              </tr>
              <tr>
                <td colspan="2">Information Group</td>
              </tr>
              <tr>
                <td>Nom Group</td>
                <td>${data.name}</td>
              </tr>
              <tr>
                <td>Responsable Group</td>
                <td>${data.responsable}</td>
              </tr>
              <tr>
                <td>Address Group</td>
                <td>${data.address}</td>
              </tr>
              <tr>
                <td>Portable Group</td>
                <td>${data.phone}</td>
              </tr>
              <tr>
                <td>Email Group</td>
                <td>${data.email}</td>
              </tr>
              <tr>
                <td>Discipline</td>
                <td>${data.discipline}</td>
              </tr>
              <tr>
                <td>Niveau Group</td>
                <td>${data.level}</td>
              </tr>
              <tr>
                <td>Titre de la musique</td>
                <td>${data.title_of_music}</td>
              </tr>
              <tr>
                <td>Compositeur·trice</td>
                <td>${data.composer}</td>
              </tr>
              <tr>
                <td>Durée de la pièce</td>
                <td>${data.length_of_piece}</td>
              </tr>
              <tr>
                <td>Âge moyen</td>
                <td>${data.average_age} ans</td>
              </tr>
              <tr>
                <td colspan="2"><strong>Participant·e·s.</strong></td>
              </tr>
              ${data.participants.map(participant => `
                <tr>
                <td>
                  <a href="https://res-3.cloudinary.com/dsyp2wb4w/image/upload/v1/production/${participant.photo}?_a=BACE6GEv" target="_blank">
                    <img src='https://res-3.cloudinary.com/dsyp2wb4w/image/upload/v1/production/${participant.photo}?_a=BACE6GEv', width="100px">
                  </a>
                </td>
                <td>${capitalize(participant.name)} ${capitalize(participant.last_name)}, ${participant.age} ans</td>
                </tr>
              `)};
            </table>`.replace(/[;,]/g, "");;
        })
        .catch(error => {
          console.error("Error fetching group data:", error);
          groupInfoDiv.innerHTML = "<p>Error loading group information.</p>";
        });
    } else {
      // Reset the group info content if no group is selected
      groupInfoDiv.innerHTML = "<p>Please select a group to view its information.</p>";
    }

  }
}
function capitalize(str) {
  if (!str) return ''; // Check for empty or null strings
  return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
}

function calculateAge(birthdate) {
  const birthday = new Date(birthdate);
  const today = new Date();

  let years = today.getFullYear() - birthday.getFullYear();
  let months = today.getMonth() - birthday.getMonth();
  let days = today.getDate() - birthday.getDate();

  // Adjust days and months if necessary
  if (days < 0) {
      months -= 1;
      const previousMonth = new Date(today.getFullYear(), today.getMonth(), 0); // Last day of the previous month
      days += previousMonth.getDate(); // Adjust days to account for the last day of the previous month
  }

  if (months < 0) {
      years -= 1;
      months += 12; // Adjust months if they are negative
  }

  // Build the age string
  let ageString = `${years} an${years !== 1 ? 's' : ''}`;
  if (months > 0) {
      ageString += `, ${months} moi${months !== 1 ? 's' : ''}`;
  }
  if (days > 0) {
      ageString += `, ${days} jour${days !== 1 ? 's' : ''}`;
  }

  return ageString;
}
