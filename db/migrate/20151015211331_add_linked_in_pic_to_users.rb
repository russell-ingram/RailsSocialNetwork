class AddLinkedInPicToUsers < ActiveRecord::Migration
  def change
    add_column :users, :linkedin_pic_url, :string
  end
end
