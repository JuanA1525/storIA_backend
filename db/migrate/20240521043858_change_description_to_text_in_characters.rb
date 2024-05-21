class ChangeDescriptionToTextInCharacters < ActiveRecord::Migration[7.1]
  def up
    change_column :characters, :description, :text
  end

  def down
    change_column :characters, :description, :string
  end
end
