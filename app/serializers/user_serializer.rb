class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :last_name, :mail, :birth_date
end
