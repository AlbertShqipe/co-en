import { Controller } from "@hotwired/stimulus"

function getScrollPosition() {
  // Get the current vertical position of the scroll bar
  const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

  // Calculate the maximum scrollable height
  const documentHeight = document.documentElement.scrollHeight;
  const viewportHeight = window.innerHeight;

  // Maximum scroll position is the height of the document minus the height of the viewport
  const maxScrollTop = documentHeight - viewportHeight;

  // Return the scroll position
  return scrollTop;
}

// Connects to data-controller="back-to-top"
export default class extends Controller {
  connect() {
    // Get the div element that contains the scroll to top button
    const icon = document.getElementById('backToTop');

    // Optionally, you can log the scroll position every time the user scrolls
    window.addEventListener('scroll', () => {
      const scrollPosition = getScrollPosition();

      if (scrollPosition <= 960) {
        icon.style.opacity = 0;
      } else {
      // Gradually increase opacity between scroll positions 860 and 1160
        let maxOpacityScroll = 2000; // Adjust this to define the scroll range over which opacity increases
        let opacity = (scrollPosition - 860) / (maxOpacityScroll - 860);

      // Clamp the opacity value between 0 and 1
        icon.style.opacity = Math.min(Math.max(opacity, 0), 1);
      }
    });
  }
}
