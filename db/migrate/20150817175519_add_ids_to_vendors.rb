class AddIdsToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :vid, :int
    add_column :sectors, :sid, :int
  end
end
