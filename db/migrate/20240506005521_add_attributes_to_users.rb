class AddAttributesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :num_phone, :integer
    add_column :users, :state, :boolean
    add_column :users, :ban, :boolean
    add_column :users, :days_ban, :integer
  end
end
