class AddNotificationSettingsToUser < ActiveRecord::Migration
  def change
    add_column :users, :message_notifications, :boolean, :default => true
    add_column :users, :connection_notifications, :boolean, :default => true
  end
end
