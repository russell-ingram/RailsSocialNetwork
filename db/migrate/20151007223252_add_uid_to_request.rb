class AddUidToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :uid, :string
  end
end
