import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="unread-notifs-count"
export default class extends Controller {
  connect() {
    let count = this.data.get("unreadcount")
    const countBadge = document.getElementById("unreadCount")
    countBadge.style.visibility = count > 0 ? 'visible' : 'hidden' 
  }
}
