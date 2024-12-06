import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("ScrollToBottomController connected");
    this.scrollToBottom();
  }

  scrollToBottom() {
    console.log("Scrolling to bottom");
    const container = document.getElementById("messages-container");
    if (container) {
      container.scrollTop = container.scrollHeight;
      console.log("Scrolled to bottom");
    }
  }

  // Ensure the controller reconnects after Turbo renders
  reconnect() {
    console.log("Turbo re-render detected");
    this.scrollToBottom();
  }
}
