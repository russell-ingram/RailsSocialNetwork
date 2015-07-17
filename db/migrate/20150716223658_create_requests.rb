class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :first_name
      t.string :last_name
      t.string :linked_in
      t.string :job_title
      t.string :company
      t.string :email

      t.timestamps null: false
    end
  end
end
