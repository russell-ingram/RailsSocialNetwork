class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :position, :string
    add_column :users, :footprint, :string
    add_column :users, :linked_in_url, :string
    add_column :users, :enterprise_size, :string
    add_column :users, :region, :string
    add_column :users, :country, :string
    add_column :users, :emp_summary, :text

    remove_column :users, :location, :string

  end
end
