class Character < ApplicationRecord
  belongs_to :user
  has_many :story_characters
  has_many :characters, through: :story_characters

  validates :name, presence: true
  validates :description, presence: true
  validates :user, presence: true
end
