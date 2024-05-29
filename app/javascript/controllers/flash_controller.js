import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["notice", "alert"]

  connect() {
    this.autoDismiss(this.noticeTarget)
    this.autoDismiss(this.alertTarget)
  }

  autoDismiss(target) {
    if (target) {
      setTimeout(() => {
        target.classList.remove('show');
      }, 3000); // Adjust the time as needed to show alert/notice
    }
  }
}
