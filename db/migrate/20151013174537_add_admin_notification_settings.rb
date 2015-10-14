class AddAdminNotificationSettings < ActiveRecord::Migration
  def change
    add_column :users, :admin_profile_notifications, :boolean, :default => true
    add_column :users, :admin_request_notifications, :boolean, :default => true
    add_column :users, :admin_activation_notifications, :boolean, :default => true
  end
end
