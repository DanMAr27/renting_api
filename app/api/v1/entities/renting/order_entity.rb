# frozen_string_literal: true

module V1
  module Entities
    module Renting
      class OrderEntity < Grape::Entity
        # 1. Order Core Info
        expose :order, merge: true do
          expose :id
          expose :order_number
          expose :status
          expose :order_date
          expose :expected_delivery_date
          expose :actual_delivery_date
          expose :is_renewal
          expose :notes
          expose :created_at
          expose :updated_at
        end

        # 2. General Info
        expose :general_info do
          expose :company do |order|
            { id: order.company.id, name: order.company.name }
          end

          expose :supplier do |order|
            { id: order.supplier.id, name: order.supplier.name }
          end

          expose :created_by do |order|
            { id: order.created_by.id, name: order.created_by.name, email: order.created_by.email }
          end
        end

        # 3. Vehicle Spec
        expose :vehicle_spec, using: OrderVehicleSpecEntity

        # 4. Contract Condition (inc. Services)
        expose :contract_condition, using: OrderContractConditionEntity
      end
    end
  end
end
