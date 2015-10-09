class AddInviteStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :invite_status, :string, :default => 'unsent'
  end
end
