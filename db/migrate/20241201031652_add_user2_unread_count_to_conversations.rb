class AddUser2UnreadCountToConversations < ActiveRecord::Migration[8.0]
  def change
    add_column :conversations, :user2_unread_count, :integer, default: 0, null: false
  end
end
