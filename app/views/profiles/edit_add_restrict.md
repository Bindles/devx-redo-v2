<% if current_user == @user %>
  <%= link_to "Edit Profile", edit_user_path(@user), class: "btn btn-secondary" %>
<% end %>
