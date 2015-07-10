class AddPeersToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :peers, :int
  end
end
