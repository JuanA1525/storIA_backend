class User < ApplicationRecord
    has_secure_password
    has_many :stories
    has_many :characters
    has_many :reviews

    # Email validations
    validates :mail, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "It must be a valid email." }
    normalizes :mail, with: -> (value) { value.strip.downcase }
  
    # Validation for date of birth
    validates :birth_date, presence: true
    validate :birth_date_in_past
  
    # First and last name validations.
    validates :name, presence: true
    validates :last_name, presence: true
  
    private
  
    def birth_date_in_past
      if birth_date.present? && birth_date > 5.years.ago.to_date
        errors.add(:birth_date, "must be at least 5 years before today")
      end
    end
  end
  