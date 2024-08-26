import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static target = "groupInfo"
  connect() {
    const groupSelect = document.getElementById("group-select");
    console.log(groupSelect)

    // if (groupSelect) {
    //   // Set up event listener for changes in the select element
    //   groupSelect.addEventListener('change', (event) => {
    //     const selectedGroupId = event.target.value;
    //     console.log(selectedGroupId)
    //     const groupInfoDiv = document.getElementById("group-info");
    //     console.log(groupInfoDiv)
    //     groupInfoDiv.innerHTML = `
    //     <h1>Group <%= selectedGroupId %></h1>
    //     <h2>Group Information</h2>
    //       <p>Group Name: <%= @groups.find(${selectedGroupId}).name %> </p>
    //       <p>Group Responsible: <%= current_user.@groups.find(${selectedGroupId}).responsable %> </p>
    //       <p>Group Address: <%= current_user.@groups.find(${selectedGroupId}).address %> </p>
    //       <p>Group Phone: <%= current_user.@groups.find(${selectedGroupId}).phone %> </p>
    //       <p>Group Email: <%= current_user.@groups.find(${selectedGroupId}).email %> </p>
    //       <p>Group Discipline: <%= current_user.@groups.find(${selectedGroupId}).discipline %> </p>
    //       <p>Group Level: <%= current_user.@groups.find(${selectedGroupId}).level %> </p>
    //       <p>Title of Music: <%= current_user.@groups.find(${selectedGroupId}).title_of_music %> </p>
    //       <p>Composer: <%= current_user.@groups.find(${selectedGroupId}).compositor %> </p>
    //       <p>Length Of Piece: <%= current_user.@groups.find(${selectedGroupId}).length_of_piece  %> </p>`;
    //   });
    // }
    if (groupSelect) {
      // Set up event listener for changes in the select element
      groupSelect.addEventListener('change', (event) => {
        const selectedGroupId = event.target.value;
        console.log("Selected Group ID:", selectedGroupId);
        this.fetchGroupInfo(selectedGroupId);
      });
    }
  }
  fetchGroupInfo(selectedGroupId) {
    const groupInfoDiv = document.getElementById("group-info");

    if (selectedGroupId) {
      // Fetch the group details using AJAX
      fetch(`/group_forms/${selectedGroupId}/info`) // Modify this route as necessary
        .then(response => response.json())
        .then(data => {
          console.log("Fetched data:", data);
          console.log(data.participants);
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
