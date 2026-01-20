# frozen_string_literal: true

module V1
  module Entities
    module Renting
      class ContractEntity < Grape::Entity
        expose :id
        expose :supplier_contract_number
        expose :duration_months
        expose :annual_km
        expose :monthly_fee
        expose :start_date
        expose :expected_end_date
        expose :actual_end_date
        expose :status
        expose :created_at
        expose :updated_at

        expose :days_until_expiration

        expose :vehicle, using: VehicleEntity

        expose :supplier do |contract|
          { id: contract.supplier.id, name: contract.supplier.name }
        end

        expose :company do |contract|
          { id: contract.company.id, name: contract.company.name }
        end

        expose :order do |contract|
          {
            id: contract.order.id,
            order_number: contract.order.order_number
          }
        end
      end
    end
  end
end
