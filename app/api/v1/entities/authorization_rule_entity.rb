module V1
  module Entities
    class AuthorizationRuleEntity < Grape::Entity
      expose :id
      expose :authorizable_type
      expose :name
      expose :condition_field
      expose :condition_operator
      expose :condition_value
      expose :required_role
      expose :approval_level
      expose :active
      expose :created_at
      expose :updated_at
    end
  end
end
