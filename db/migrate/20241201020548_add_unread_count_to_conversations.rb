class AddUnreadCountToConversations < ActiveRecord::Migration[8.0]
  def change
    add_column :conversations, :unread_count, :integer, default: 0, null: false
  end
end
