class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :story, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :review
      t.boolean :state

      t.timestamps
    end
  end
end
