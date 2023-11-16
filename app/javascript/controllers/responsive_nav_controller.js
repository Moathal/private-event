import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.querySelectorAll(".actual").forEach((link) => {
			link.addEventListener("click", this.hide.bind(this));
		});
  }

  hide() {
    var offcanvas = document.querySelector('#offcanvasNavbar');
    var shadowBackground = document.querySelector('.offcanvas-backdrop')
    offcanvas.classList.remove('show');
    this.element.querySelectorAll(".actual").forEach(element => {
      element.classList.remove('active')      
    });
    offcanvas.classList.add('active');
    shadowBackground.classList.remove("show");
  }
}