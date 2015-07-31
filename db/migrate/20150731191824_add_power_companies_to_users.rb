class AddPowerCompaniesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :big65, :boolean
    add_column :users, :fortune100, :boolean
    add_column :users, :sp500, :boolean
    add_column :users, :global1000, :boolean
    add_column :users, :timezone, :string
  end
end
