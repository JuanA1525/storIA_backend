class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.references :review, null: false, foreign_key: true
      t.string :report
      t.string :comment
      t.boolean :state

      t.timestamps
    end
  end
end
