class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :last_name
      t.string :password
      t.date :birth_date
      t.string :mail

      t.timestamps
    end
  end
end
