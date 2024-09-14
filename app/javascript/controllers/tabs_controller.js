import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static target = ["groupInfo", "soloInfo" , "duoInfo", "trioInfo"]
  connect() {
    const soloSelect = document.getElementById("solo-select");
    const duoSelect = document.getElementById("duo-select");
    const trioSelect = document.getElementById("trio-select");
    const groupSelect = document.getElementById("group-select");

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
  }
  fetchSoloInfo(selectedSoloId) {
    const soloInfoDiv = document.getElementById("solo-info");

    if (selectedSoloId) {
      // Fetch the solo details using AJAX
      fetch(`/solos/${selectedSoloId}/info`) // Modify this route as necessary
        .then(response => response.json())
        .then(data => {
          // console.log("Fetched data:", data);
          // Populate the HTML with the fetched data
          soloInfoDiv.innerHTML = `
            <h1>Solo ${data.id}</h1>
            <h2>Solo Information</h2>
            <p>Solo Name: ${data.name}</p>
            <p>Solo Last Name: ${data.last_name}</p>
            <p>SoloBirthday: ${data.birth_date}</p>
            <p>Solo Address: ${data.address}</p>
            <p>Solo Phone: ${data.phone}</p>
            <p>Solo Email: ${data.email}</p>
            <p>Solo Style: ${data.style}</p>
            <p>Solo Level: ${data.level}</p>
            <p>Category: ${data.category}</p>
            <p>Dance School: ${data.dance_school}</p>
            <p>Teacher: ${data.teacher_name}</p>
            <p>Teacher Phone: ${data.teacher_phone}</p>
            <p>Teacher Email: ${data.teacher_email}</p>`;
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
          // console.log("Fetched data:", data);
          // console.log(data.participants);
          // Populate the HTML with the fetched data
          duoInfoDiv.innerHTML = `
            <h1>Duo ${data.id}</h1>
            <h2>Duo Information</h2>
            <p>Duo Name: ${data.name}</p>
            <p>Duo Responsible: ${data.responsable}</p>
            <p>Duo Address: ${data.address}</p>
            <p>Duo Phone: ${data.phone}</p>
            <p>Duo Email: ${data.email}</p>
            <p>Duo Discipline: ${data.discipline}</p>
            <p>Duo Level: ${data.level}</p>
            <p>Title of Music: ${data.title_of_music}</p>
            <p>Composer: ${data.composer}</p>
            <p>Length Of Piece: ${data.length_of_piece}</p>
            <h3>Participants</h3>
            <ul style="list-style-type:none; padding:0; margin:0; display:flex; justify-content:center ">
              ${data.participants.map(participant => `<li style="padding:0; margin:0">${participant.name} ${participant.last_name}</li>`)};
            </ul>`;
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
          // console.log("Fetched data:", data);
          // console.log(data.participants);
          // Populate the HTML with the fetched data
          trioInfoDiv.innerHTML = `
            <h1>Trio ${data.id}</h1>
            <h2>Trio Information</h2>
            <p>Trio Name: ${data.name}</p>
            <p>Trio Responsible: ${data.responsable}</p>
            <p>Trio Address: ${data.address}</p>
            <p>Trio Phone: ${data.phone}</p>
            <p>Trio Email: ${data.email}</p>
            <p>Trio Discipline: ${data.discipline}</p>
            <p>Trio Level: ${data.level}</p>
            <p>Title of Music: ${data.title_of_music}</p>
            <p>Composer: ${data.composer}</p>
            <p>Length Of Piece: ${data.length_of_piece}</p>
            <h3>Participants</h3>
            <ul style="list-style-type:none; padding:0; margin:0; display:flex; justify-content:center ">
              ${data.participants.map(participant => `<li style="padding:0; margin:0">${participant.name} ${participant.last_name}</li>`)};
            </ul>`;
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
          // console.log("Fetched data:", data);
          // console.log(data.participants);
          // Populate the HTML with the fetched data
          groupInfoDiv.innerHTML = `
            <h1>Group ${data.id}</h1>
            <h2>Group Information</h2>
            <p>Group Name: ${data.name}</p>
            <p>Group Responsible: ${data.responsable}</p>
            <p>Group Address: ${data.address}</p>
            <p>Group Phone: ${data.phone}</p>
            <p>Group Email: ${data.email}</p>
            <p>Group Discipline: ${data.discipline}</p>
            <p>Group Level: ${data.level}</p>
            <p>Title of Music: ${data.title_of_music}</p>
            <p>Composer: ${data.composer}</p>
            <p>Length Of Piece: ${data.length_of_piece}</p>
            <h3>Participants</h3>
            <ul style="list-style-type:none; padding:0; margin:0; display:flex; justify-content:center ">
              ${data.participants.map(participant => `<li style="padding:0; margin:0">${participant.name} ${participant.last_name}</li>`)};
            </ul>`;
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
