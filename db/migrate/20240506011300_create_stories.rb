class CreateStories < ActiveRecord::Migration[7.1]
  def change
    create_table :stories do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.string :content
      t.boolean :state
      
      t.timestamps
    end
  end
end
