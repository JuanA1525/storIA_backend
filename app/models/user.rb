class User < ApplicationRecord
    has_secure_password
  
    # Validaciones para mail
    validates :mail, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Debe ser un correo válido." }
    normalizes :mail, with: -> (value) { value.strip.downcase }
  
    # Validación para fecha de nacimiento
    validates :birth_date, presence: true
    validate :birth_date_in_past
  
    # Validaciones para nombre y apellido
    validates :name, presence: true
    validates :last_name, presence: true
  
    private
  
    def birth_date_in_past
      if birth_date.present? && birth_date > 5.years.ago.to_date
        errors.add(:birth_date, "debe ser al menos de 5 años antes de hoy")
      end
    end
  end
  