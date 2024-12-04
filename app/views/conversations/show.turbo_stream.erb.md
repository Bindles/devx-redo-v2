<turbo-stream target="conversation_<%= @conversation.id %>">
  <template>
    <p>
      <%= @conversation.user1.username %> and <%= @conversation.user2.username %>
    </p>
  </template>
</turbo-stream>
