class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :last_name, null: false
      t.string :password_digest
      t.date :birth_date, null: false
      t.string :mail, null: false

      t.timestamps
    end
  end
end
