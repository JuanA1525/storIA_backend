class Story < ApplicationRecord
  belongs_to :user
  has_many :reviews
  has_many :story_characters
  has_many :characters, through: :story_characters
end
