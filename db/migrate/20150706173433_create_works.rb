class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :company
      t.string :industry
      t.string :enterprise_size
      t.string :region
      t.string :country
      t.string :start_date
      t.string :end_date
      t.text :summary
      t.boolean :current
      t.boolean :public

      t.timestamps null: false
    end
  end
end
