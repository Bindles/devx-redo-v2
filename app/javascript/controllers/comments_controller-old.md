import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { postId: Number };

  loadMore() {
    fetch(`/posts/${this.postIdValue}/comments`)
      .then(response => response.text())
      .then(html => {
        this.element.innerHTML = html;
      });
  }

  hideAll() {
    fetch(`/posts/${this.postIdValue}/comments?limit=3`)
      .then(response => response.text())
      .then(html => {
        this.element.innerHTML = html;
      });
  }
}
