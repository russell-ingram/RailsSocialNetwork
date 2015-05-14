class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :type_of_content, default: "news"
      t.string :name
      t.string :headline
      t.text :body_copy
      t.string :link_copy
      t.string :link_url

      t.boolean :active, :default => false

      t.integer :layout_option
      t.string :layout_html_url

      t.timestamps null: false
    end

    add_index :contents, [:type_of_content, :active]

  end
end
