class AddFieldsToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :clevel, :boolean
    add_column :searches, :executive, :boolean
    add_column :searches, :president, :boolean
    add_column :searches, :director, :boolean
    add_column :searches, :principal, :boolean
    add_column :searches, :head, :boolean
    add_column :searches, :senior, :boolean
    add_column :searches, :lead, :boolean
    add_column :searches, :manager, :boolean
    add_column :searches, :architect, :boolean
    add_column :searches, :infrastructure, :boolean
    add_column :searches, :engineer, :boolean
    add_column :searches, :consultant, :boolean
    add_column :searches, :security, :boolean
    add_column :searches, :analyst, :boolean
    add_column :searches, :administrator, :boolean
    add_column :searches, :risk, :boolean
  end
end
