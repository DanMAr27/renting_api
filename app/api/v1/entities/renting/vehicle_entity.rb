# frozen_string_literal: true

module V1
  module Entities
    module Renting
      class VehicleEntity < Grape::Entity
        expose :id
        expose :license_plate
        expose :vin
        expose :color
        expose :fuel_type
        expose :transmission
        expose :delivery_date
        expose :initial_km
        expose :current_km
        expose :status
        expose :created_at
        expose :updated_at

        expose :vehicle_type, using: VehicleTypeEntity

        expose :order do |vehicle|
          {
            id: vehicle.order.id,
            order_number: vehicle.order.order_number,
            status: vehicle.order.status
          }
        end

        # Available actions for detail view
        expose :available_actions, using: V1::Entities::Renting::AvailableActionsCollectionEntity, if: ->(instance, options) { options[:type] == :detail }
      end
    end
  end
end
