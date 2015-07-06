class AddValuesToWorks < ActiveRecord::Migration
  def change
    add_column :works, :user_id, :int
  end
end
