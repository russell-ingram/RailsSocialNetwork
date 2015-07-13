class AddUidToWorks < ActiveRecord::Migration
  def change
    add_column :works, :uid, :string
  end
end
