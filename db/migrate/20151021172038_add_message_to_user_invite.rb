class AddMessageToUserInvite < ActiveRecord::Migration
  def change
    add_column :users, :invite_message, :text
  end
end
