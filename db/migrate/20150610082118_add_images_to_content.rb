class AddImagesToContent < ActiveRecord::Migration
  def change
    add_column :contents, :image_url, :string
  end
end
