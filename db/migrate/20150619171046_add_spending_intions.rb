class AddSpendingIntions < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
    create_table :sectors do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
    add_reference :intentions, :sector, index: true, foreign_key: true
    add_reference :intentions, :vendor, index: true, foreign_key: true
    remove_column :intentions, :sector, :string

  end
end
