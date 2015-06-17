class CreateIntentions < ActiveRecord::Migration
  def change
    create_table :intentions do |t|
      t.integer :intention_id
      t.integer :search_id

      t.string :intention
      t.string :sector

      t.timestamps null: false
    end
  end
end
