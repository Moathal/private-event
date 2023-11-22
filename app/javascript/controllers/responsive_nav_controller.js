import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    var className = `.${this.data.get("classname")}`;
    document.querySelectorAll(className).forEach((link) => {
			link.addEventListener("click", (event) => this.hideShow(event.target, className));
		});
  }

  hideShow(element, className) {
    document.querySelectorAll(className).forEach(item => {
      item.classList.remove('active')      
      item.classList.remove('show')
      item.setAttribute("aria-selected", "false")      
    });
     className === ".actual" ? this.main_nav(element) : this.event_nav(element, document.getElementById(this.data.get("eleId")))
  }

  main_nav(navButton){
    let xButton = document.querySelector('.btn-close');
    navButton.classList.add('active');
    navButton.setAttribute("aria-selected", "true");
    xButton.click();
  }

  event_nav(navTab, pane){
    document.querySelectorAll('.tab-link').forEach((element) => {
      element.classList.remove('active')
      element.setAttribute("aria-selected", "false")
    })
    navTab.classList.add('active')
    navTab.setAttribute("aria-selected", "true")
    pane.classList.add(active)
    pane.classList.add(show)
  }
}
