class AddResultsToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :results, :text
  end
end
