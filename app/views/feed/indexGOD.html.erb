<%# app/views/friendships/index_posts.html.erb %>
<div class="xxx" id="xxx">Z:</div>

<div id="posts">
  <% @posts.each do |post| %>
    <%= render post %>
    <p>
      <%= link_to "Show this post", post %>
    </p>
  <% end %>
</div>

<%= turbo_stream_from :posts_list %>

<span id="posts_count">
  <%= Post.count %>
</span>
  <!-- All Users Section -->
  <h1 class="text-center mb-4">All Users' Posts</h1>
  <div class="container">
    <% if @posts.any? %>
      <div class="row">
          <% @posts.each  do |post| %>
          
            <div class="col-md-4 mb-4">
              <div class="card">
                <div class="card-body text-center">
                  <img src="<%= user.profile.avatar_url || 'https://i.ibb.co/JzVRDVg/83fddc68a0c7.png' %>" 
                      alt="Avatar" class="rounded-circle mb-3" style="width: 100px; height: 100px; object-fit: cover;">
                  <h5 class="card-title"><%= user.username %></h5>
                  <p class="card-text text-muted"><%= truncate(post.body, length: 150) %></p>
    <%= turbo_stream_from post %>
                  <div class="d-flex gap-3 justify-content-center">
                    <%= link_to "Comments #{post.comments.count}", '#', class: "btn btn-info btn-sm text-white" %>
                    <% if current_user.friends.include?(user) %>
                      <button class="btn btn-secondary btn-sm" disabled>
                        <i class="bi bi-check-circle"></i> Friend
                      </button>
                    <% else %>
                      <%= button_to "Add Friend", friendships_path(friend_id: user.id), method: :post, class: "btn btn-success btn-sm" %>
                    <% end %>
                    <%= link_to "View Profile", user_profile_path(user.id), class: "btn btn-primary btn-sm text-white" %>
                  </div>
                </div>





    <div id="comments" data-controller="comments">
      <!-- Scrollable Comments Section -->
      <div 
        style="max-height: 200px; overflow-y: auto; border: 1px solid #ccc; border-radius: 5px; padding: 10px;">
        <div id="comments"></div>
        <!-- Preview Comments -->
        <div data-comments-target="preview">
          <%= render post.comments.last(3).reverse %>
        </div>

        <!-- Hidden All Comments -->
        <div data-comments-target="all" style="display: none;">
          <%= render post.comments.order(created_at: :desc) %>
        </div>
      </div>

      <!-- Show/Hide Buttons -->
      <% if post.comments.size > 3 %>
        <div class="mt-2">
          <button 
            data-action="click->comments#showAll" 
            data-comments-target="showButton" 
            class="btn btn-outline-primary btn-sm">
            Show All Comments
          </button>
          <button 
            data-action="click->comments#hideAll" 
            data-comments-target="hideButton" 
            class="btn btn-outline-secondary btn-sm" 
            style="display: none;">
            Hide Comments
          </button>
        </div>
      <% end %>
    </div>        


  <button 
    class="btn btn-primary btn-sm" 
    type="button" 
    data-bs-toggle="collapse" 
    data-bs-target="#<%= dom_id(post, :new_comment_form) %>" 
    aria-expanded="false" 
    aria-controls="<%= dom_id(post, :new_comment_form) %>">
    Add a Comment
  </button>

  <!-- Comment Form -->
  <div id="<%= dom_id(post, :new_comment_form) %>" class="collapse">
    <%= render 'comments/new', commentable: post, post: post %>
  </div>


              </div>
            </div>
          <% end %>
        <% end %>
      </div>
    <% else %>
      <p class="text-muted text-center">No posts found from users.</p>
    <% end %>
  </div>
