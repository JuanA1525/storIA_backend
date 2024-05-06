class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.string :description
      t.boolean :state

      t.timestamps
    end
  end
end
