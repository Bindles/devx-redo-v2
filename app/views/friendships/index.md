<%# app/views/friendships/index.html.erb %>
<h1 class="text-center mb-4">Search Users</h1>

<!-- Search Form -->
<div class="container">
  <%= form_with url: friendships_path, method: :get, local: true, class: "d-flex justify-content-center" do |form| %>
    <div class="input-group w-50">
      <%= form.text_field :query, placeholder: "Search by username", class: "form-control" %>
      <button class="btn btn-primary" type="submit">Search</button>
    </div>
  <% end %>
</div>

<% if params[:query].present? %>

<!-- Search Results -->
<h2 class="text-center mt-5">Results</h2>
<div class="container mt-4">
  <% if @users.any? %>
    <div class="row">
      <% @users.each do |user| %>
        <div class="col-md-4 mb-4">
          <div class="card">
            <div class="card-body text-center">
              <img src="<%= user.profile.avatar_url || 'https://i.ibb.co/JzVRDVg/83fddc68a0c7.png' %>" 
                   alt="Avatar" class="rounded-circle mb-3" style="width: 100px; height: 100px; object-fit: cover;">
              <h5 class="card-title"><%= user.username %></h5>
              <p class="card-text text-muted"><%= truncate(user.profile.bio, length: 50) %></p>
              
              <!-- Buttons Side by Side for Search Results with Adjusted Spacing -->
              <div class="d-flex gap-3 justify-content-center">
                <% if current_user.friends.include?(user) %>
                  <button class="btn btn-secondary btn-sm" disabled>
                    <i class="bi bi-check-circle"></i> Friend
                  </button>
                <% else %>
                  <%= button_to "Add Friend", friendships_path(friend_id: user.id), 
                                method: :post, 
                                class: "btn btn-success btn-sm" %>
                <% end %>

                <!-- View Profile Button (Darker Blue) for Search Results -->
                <%= link_to "View Profile", user_profile_path(user.id), 
                            class: "btn btn-primary btn-sm text-white" %>
              </div>
            </div>
          </div>
        </div>
      <% end %>
    </div>
  <% else %>
    <p class="text-muted text-center">No users found matching your search.</p>
  <% end %>
</div>

<% end %>

<hr class="my-5">

<!-- Friends Section -->
<h1 class="text-center mb-4">Friends</h1>
<div class="container">
  <% if @friends.any? %>
    <div class="row">
      <% @friends.each do |friend| %>
        <div class="col-md-4 mb-4">
          <div class="card">
            <div class="card-body text-center">
              <img src="<%= friend.profile.avatar_url || 'https://i.ibb.co/JzVRDVg/83fddc68a0c7.png' %>" 
                   alt="Avatar" class="rounded-circle mb-3" style="width: 100px; height: 100px; object-fit: cover;">
              <h5 class="card-title"><%= link_to friend.username? ? friend.username : friend.email, user_profile_path(friend.id), class: "text-primary" %></h5>
              <p class="card-text text-muted"><%= truncate(friend.profile.bio, length: 50) %></p>
              <%= button_to "Delete", friendship_path(friend.id), 
                            method: :delete, 
                            data: { confirm: "Are you sure you want to remove this friend?" }, 
                            class: "btn btn-danger btn-sm" %>

              <!-- View Profile Button (Darker Blue) for Friends -->
              <%= link_to "View Profile", user_profile_path(friend.id), 
                          class: "btn btn-primary btn-sm text-white mt-2" %>
            </div>
          </div>
        </div>
      <% end %>
    </div>
  <% else %>
    <p class="text-muted text-center">You have no friends yet.</p>
  <% end %>
</div>

<hr class="my-5">

<!-- All Users Section -->
<h1 class="text-center mb-4">All Users</h1>
<div class="container">
  <% if @all_users.any? %>
    <div class="row">
      <% @all_users.each do |user| %>
        <div class="col-md-4 mb-4">
          <div class="card">
            <div class="card-body text-center">
              <img src="<%= user.profile.avatar_url || 'https://i.ibb.co/JzVRDVg/83fddc68a0c7.png' %>" 
                   alt="Avatar" class="rounded-circle mb-3" style="width: 100px; height: 100px; object-fit: cover;">
              <h5 class="card-title"><%= user.username? ? user.username : user.email %></h5>
              <p class="card-text text-muted"><%= truncate(user.profile.bio, length: 50) %></p>
              
              <!-- Buttons Side by Side for All Users with Adjusted Spacing -->
              <div class="d-flex gap-3 justify-content-center">
                <% if current_user.friends.include?(user) %>
                  <button class="btn btn-secondary btn-sm" disabled>
                    <i class="bi bi-check-circle"></i> Friend
                  </button>
                <% else %>
                  <%= button_to "Add Friend", friendships_path(friend_id: user.id), 
                                method: :post, 
                                class: "btn btn-success btn-sm" %>
                <% end %>

                <!-- View Profile Button (Darker Blue) for All Users -->
                <%= link_to "View Profile", user_profile_path(user.id), 
                            class: "btn btn-primary btn-sm text-white" %>
              </div>
            </div>
          </div>
        </div>
      <% end %>
    </div>
  <% else %>
    <p class="text-muted text-center">No other users available.</p>
  <% end %>
</div>
