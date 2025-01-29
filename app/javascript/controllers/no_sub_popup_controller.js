// import { Controller } from "@hotwired/stimulus"

// // Connects to data-controller="no-sub-popup"
// export default class extends Controller {
//   connect() {
//     if (!sessionStorage.getItem('popupDismissed')) {
//       this.showPopup();
//     }
//   }

//   showPopup() {
//     const popUp = document.getElementById('popup-end-sub');
//     popUp.style.display = 'flex';
//   }

//   dismissPopup() {
//     const popUp = document.getElementById('popup-end-sub');
//     popUp.style.display = 'none';
//     sessionStorage.setItem('popupDismissed', true);
//     this.dismissPopupOnServer();
//   }

//   dismissPopupOnServer() {
//     fetch('/dismiss_popup_end_sub', {
//       method: 'GET',
//       headers: {
//         'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
//       }
//     });
//   }
// }
