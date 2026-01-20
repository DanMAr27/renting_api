# frozen_string_literal: true

module V1
  module Entities
    module Renting
      class OrderContractConditionEntity < Grape::Entity
        expose :id
        expose :duration_months
        expose :annual_km
        expose :monthly_fee
        expose :initial_payment
        expose :deposit
        expose :contract_start_date
        expose :contract_end_date

        expose :services, using: V1::Entities::Renting::ServiceEntity do |condition|
          condition.order&.services
        end
      end
    end
  end
end
