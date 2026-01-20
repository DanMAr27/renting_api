module V1
  module Entities
    class AuthorizationApprovalEntity < Grape::Entity
      expose :id
      expose :approval_level
      expose :action
      expose :notes
      expose :approved_at
      expose :created_at

      expose :approver, using: V1::Entities::UserEntity
    end
  end
end
