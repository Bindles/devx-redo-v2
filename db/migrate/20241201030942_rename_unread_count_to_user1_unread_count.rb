class RenameUnreadCountToUser1UnreadCount < ActiveRecord::Migration[8.0]
  def change
    rename_column :conversations, :unread_count, :user1_unread_count
  end
end
