class ChangeContentLinkName < ActiveRecord::Migration
  def change
    rename_column :contents, :link_url, :external_link
  end
end
