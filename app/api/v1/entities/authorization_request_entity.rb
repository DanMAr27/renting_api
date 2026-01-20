module V1
  module Entities
    class AuthorizationRequestEntity < Grape::Entity
      expose :id
      expose :authorizable_type
      expose :authorizable_id
      expose :amount
      expose :status
      expose :current_level
      expose :max_level
      expose :created_at
      expose :completed_at

      expose :requested_by, using: V1::Entities::UserEntity
      expose :approvals, using: V1::Entities::AuthorizationApprovalEntity

      expose :can_approve do |request, options|
        current_user = options[:current_user]
        current_user ? request.can_approve?(current_user) : false
      end
    end
  end
end
