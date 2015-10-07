class AddStatusToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :accepted, :boolean
    add_column :requests, :invite_sent, :boolean
  end
end
