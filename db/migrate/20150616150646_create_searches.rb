class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.integer :user_id
      t.integer :search_id
      t.string :name
      t.string :industry
      t.string :enterprise
      t.string :organization_type
      t.string :region
      t.string :country
      t.string :job_title

      t.timestamps null: false
    end
  end
end
