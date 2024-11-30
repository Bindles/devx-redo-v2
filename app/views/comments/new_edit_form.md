<%= form_with model: [@post, Comment.new], local: true do |form| %>
  <%= form.hidden_field :commentable_type, value: "Post" %>
  <%= form.hidden_field :commentable_id, value: @post.id %>
  <div class="form-group">
    <%= form.label :content, "Your Comment:" %>
    <%= form.text_area :content, rows: 3 %>
  </div>
  <%= form.submit "Post Comment" %>
<% end %>
