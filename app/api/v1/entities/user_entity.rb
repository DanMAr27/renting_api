module V1
  module Entities
    class UserEntity < Grape::Entity
      expose :id
      expose :email
      expose :name
      expose :role
      expose :active
    end
  end
end
