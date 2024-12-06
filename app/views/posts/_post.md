<%# app/views/posts/_post.html.erb %>



<div id="<%= dom_id post %>">
  <p>
    <strong>Title:</strong>
    <%= post.title %>
  </p>

  <p>
    <strong>Body:</strong>
    <%= post.body %>
  </p>
  <% if @post%>
    <%= post.user %>
  <p>
    <strong>Body:</strong>
    <%= @post.user.inspect %>
  </p> 
  <% end %>

</div>








<div id="<%= dom_id post %>">
<div id="tst_#{post.id}">

</div>
  <p>
    <strong>Title:</strong>
    <%= post.title %>
  </p>

  <p>
    <strong>Body:</strong>
    <%= post.body %>
  </p>
  <%= post.comments.inspect %>
  <%= post.user.inspect %>
<br><br>
<a href="/posts?which_post=<%= post.id %>">Click </a>

<% post.comments.drop(1).each do |x|%>
  <%= x.content %><br>
  <%= x.user.username %><br>
  <br>
<% if params[:which_post] == post.id.to_s %>
<%#= turbo_stream.append "post_#{post.id}", 'XXXXXX' %>
<%= turbo_stream.append "post_#{post.id}", x.user.username + ':' + x.content %>
  <%# <%= render turbo_stream.append(:comy, 'aaa') %> %>
<% end %>  
<% end %>
<div id="tst">

</div>


<% if params[:xx]%>
<%= turbo_stream.update "tst", "Pass set to" %>
  <%# <%= render turbo_stream.append(:comy, 'aaa') %> %>
<% end %>

<%= turbo_frame_tag :comy %>


  <% if @post%>
    <%= post.user %>
  <p>
    <strong>Body:</strong>
    <%= @post.user.inspect %>
  </p> 
  <% end %>

</div>
