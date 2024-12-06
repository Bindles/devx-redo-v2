import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // Function to scroll the messages container to the bottom
  scrollToBottom() {
    const messagesContainer = document.getElementById("messages-container");
    if (messagesContainer) {
      messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }
  }
}
