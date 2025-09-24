// app/javascript/controllers/navbar_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.highlightActiveLink();
  }

  highlightActiveLink() {
    const currentPath = window.location.pathname;
    const navLinks = this.element.querySelectorAll('.nav-link');

    navLinks.forEach(link => {
      link.classList.remove('active');
      link.removeAttribute('aria-current');

      if (link.getAttribute('href') === currentPath) {
        link.classList.add('active');
        link.setAttribute('aria-current', 'page');
      }
    });
  }
}