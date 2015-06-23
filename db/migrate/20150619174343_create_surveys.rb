class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.integer :survey_id
      t.datetime :date_taken

      t.timestamps null: false
    end
    add_reference :intentions, :survey, index: true, foreign_key: true
    add_reference :intentions, :user, index: true, foreign_key: true
  end
end
