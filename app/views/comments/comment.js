function fetchComments(postId) {
  const commentsList = document.getElementById(`comments-list-${postId}`);
  const showBtn = document.getElementById(`show-btn-${postId}`);
  const hideBtn = document.getElementById(`hide-btn-${postId}`);

  fetch(`/posts/${postId}/comments.json`)
    .then((response) => response.json())
    .then((comments) => {
      commentsList.innerHTML = ""; // Clear existing comments
      comments.forEach((comment) => {
        const li = document.createElement("li");
        li.innerHTML = `<strong>${comment.user.name}:</strong> ${comment.body}`;
        commentsList.appendChild(li);
      });

      // Toggle Buttons
      showBtn.classList.add("d-none");
      hideBtn.classList.remove("d-none");
    });
}

function hideComments(postId) {
  const commentsList = document.getElementById(`comments-list-${postId}`);
  const showBtn = document.getElementById(`show-btn-${postId}`);
  const hideBtn = document.getElementById(`hide-btn-${postId}`);

  // Reset to recent comments
  commentsList.innerHTML = `<li>Loading...</li>`; // Placeholder while reloading
  fetch(`/posts/${postId}/comments?limit=3`)
    .then((response) => response.json())
    .then((comments) => {
      commentsList.innerHTML = "";
      comments.slice(-3).forEach((comment) => {
        const li = document.createElement("li");
        li.innerHTML = `<strong>${comment.user.name}:</strong> ${comment.body}`;
        commentsList.appendChild(li);
      });
    });

  // Toggle Buttons
  showBtn.classList.remove("d-none");
  hideBtn.classList.add("d-none");
}
