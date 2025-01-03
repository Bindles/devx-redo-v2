## PRIOR TO SEPERATING @conversations(searching)
<h1 class="text-center mb-4">Conversations</h1>

<!-- Search Form -->
<div class="container">
  <%= form_with url: conversations_path, method: :get, local: true, class: "d-flex justify-content-center" do |form| %>
    <div class="input-group w-50">
      <%= form.text_field :query, placeholder: "Search by username", class: "form-control" %>
      <button class="btn btn-primary" type="submit">Search</button>
    </div>
  <% end %>
</div>

<!-- Conversations List -->
<div class="container mt-5">
  <% if @conversations.any? %>
    <div class="row">
      <% @conversations.each do |conversation| %>
        <% friend = conversation.user1 == current_user ? conversation.user2 : conversation.user1 %>
        <div class="col-md-4 mb-4">
          <div class="card">
            <div class="card-body text-center">
              <!-- Avatar -->
              <img src="<%= friend.profile.avatar_url || 'https://i.ibb.co/JzVRDVg/83fddc68a0c7.png' %>" 
                   alt="Avatar" class="rounded-circle mb-3" style="width: 100px; height: 100px; object-fit: cover;">
              
              <!-- Username -->
              <h5 class="card-title"><%= friend.username %></h5>
              
              <!-- Unread Message Indicator -->
              <%# unread_count = conversation.messages.where(read: false, recipient: current_user).count %>
              <%# if unread_count.positive? %>
                <span class="badge bg-danger">Unread: <%#= unread_count %></span>
              <%# else %>
                <span class="badge bg-success">All Read</span>
              <%# end %>
              
              <!-- Link to Conversation -->
              <%= link_to "Open Conversation", conversation_path(conversation), class: "btn btn-primary mt-3" %>
            </div>
          </div>
        </div>
      <% end %>
    </div>
  <% else %>
    <p class="text-muted text-center">No conversations found.</p>
  <% end %>
</div>


## AFTER SEPERATING @conversations(searching):

<%# app/views/conversations/index.html.erb %>
<h1 class="text-center mb-4">Conversations</h1>

<!-- Search Form -->
<div class="container">
  <%= form_with url: conversations_path, method: :get, local: true, class: "d-flex justify-content-center" do |form| %>
    <div class="input-group w-50">
      <%= form.text_field :query, placeholder: "Search by username", class: "form-control" %>
      <button class="btn btn-primary" type="submit">Search</button>
    </div>
  <% end %>
</div>

<% if params[:query].present? %>
  <!-- Search Results -->
  <h2 class="text-center mt-5">Search Results</h2>
  <div class="container mt-4">
    <% if @searched_conversations.any? %>
      <div class="row">
        <% @searched_conversations.each do |conversation| %>
          <% friend = conversation.user1 == current_user ? conversation.user2 : conversation.user1 %>
          <div class="col-md-4 mb-4">
            <div class="card">
              <div class="card-body text-center">
                <!-- Avatar -->
                <img src="<%= friend.profile.avatar_url || 'https://i.ibb.co/JzVRDVg/83fddc68a0c7.png' %>" 
                     alt="Avatar" class="rounded-circle mb-3" style="width: 100px; height: 100px; object-fit: cover;">
                
                <!-- Username -->
                <h5 class="card-title"><%= friend.username %></h5>

              <!-- Unread Message Indicator -->
              <%# unread_count = conversation.messages.where(read: false, recipient: current_user).count %>
              <%# if unread_count.positive? %>
                <span class="badge bg-danger">Unread: <%#= unread_count %></span>
              <%# else %>
                <span class="badge bg-success">All Read</span>
              <%# end %>                
                
                <!-- Link to Conversation -->
                <%= link_to "Open Conversation", conversation_path(conversation), class: "btn btn-primary mt-3" %>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    <% else %>
      <p class="text-muted text-center">No conversations found matching your search.</p>
    <% end %>
  </div>
  <hr class="my-5">
<% end %>

<!-- All Conversations -->
<h2 class="text-center mb-4">Your Conversations</h2>
<div class="container">
  <% if @conversations.any? %>
    <div class="row">
      <% @conversations.each do |conversation| %>
        <% friend = conversation.user1 == current_user ? conversation.user2 : conversation.user1 %>
        <div class="col-md-4 mb-4">
          <div class="card">
            <div class="card-body text-center">
              <!-- Avatar -->
              <img src="<%= friend.profile.avatar_url || 'https://i.ibb.co/JzVRDVg/83fddc68a0c7.png' %>" 
                   alt="Avatar" class="rounded-circle mb-3" style="width: 100px; height: 100px; object-fit: cover;">
              
              <!-- Username -->
              <h5 class="card-title"><%= friend.username %></h5>

              <!-- Unread Message Indicator -->
              <%# unread_count = conversation.messages.where(read: false, recipient: current_user).count %>
              <%# if unread_count.positive? %>
                <span class="badge bg-danger">Unread: <%#= unread_count %></span>
              <%# else %>
                <span class="badge bg-success">All Read</span>
              <%# end %>              
              
              <!-- Link to Conversation -->
              <%= link_to "Open Conversation", conversation_path(conversation), class: "btn btn-primary mt-3" %>
            </div>
          </div>
        </div>
      <% end %>
    </div>
  <% else %>
    <p class="text-muted text-center">You have no active conversations.</p>
  <% end %>
</div>
