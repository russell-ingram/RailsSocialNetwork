class AddMoreToWorks < ActiveRecord::Migration
  def change
    add_column :works, :job_title, :string
    add_column :works, :footprint, :string
  end
end
