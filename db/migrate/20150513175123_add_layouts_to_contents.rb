class AddLayoutsToContents < ActiveRecord::Migration
  def change
    add_column :contents, :column_one_callout, :string
    add_column :contents, :column_two_callout, :string
    add_column :contents, :column_three_callout, :string

    add_column :contents, :column_one_content, :text
    add_column :contents, :column_two_content, :text
    add_column :contents, :column_three_content, :text

  end
end
