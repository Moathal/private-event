import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  clickEventNav(event) {
    let tabPaneAttendances = `.${this.data.get("classname")}`;
    const navTab = event.currentTarget;
    const pane = document.getElementById(this.data.get("eleId"));

    this.hideShow(navTab, tabPaneAttendances);
  }
  
  clickMainNav(event) {
    let actualLink = `.${this.data.get("classname")}`;
    const navButton = event.target;

    this.hideShow(navButton, actualLink);
  }

  hideShow(element, className) {
    document.querySelectorAll(className).forEach(item => {
      item.classList.remove('active');      
      item.classList.remove('show');
      item.setAttribute("aria-selected", "false");
    });
      if (className === ".actual") return this.main_nav(element);
      if (className === ".tab-pane") return this.event_nav(element, document.getElementById(this.data.get("eleId")));
  }

  main_nav(navButton){
    let xButton = document.querySelector('.btn-close');
    navButton.classList.add('active');
    navButton.setAttribute("aria-selected", "true");
    xButton.click();
  }

  event_nav(navTab, pane){
    document.querySelectorAll('.tab-link').forEach((element) => {
      element.classList.remove('active');
      element.setAttribute("aria-selected", "false");
    })
    navTab.classList.add('active')
    navTab.setAttribute("aria-selected", "true");
    pane.classList.add('active');
    pane.classList.add('show');
  }
}
