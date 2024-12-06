import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["preview", "all", "showButton", "hideButton"];

  showAll() {
    // Show all comments and toggle button visibility
    this.previewTarget.style.display = "none";
    this.allTarget.style.display = "block";
    this.showButtonTarget.style.display = "none";
    this.hideButtonTarget.style.display = "inline-block";
  }

  hideAll() {
    // Show the preview and hide the rest of the comments
    this.previewTarget.style.display = "block";
    this.allTarget.style.display = "none";
    this.showButtonTarget.style.display = "inline-block";
    this.hideButtonTarget.style.display = "none";
  }
}
