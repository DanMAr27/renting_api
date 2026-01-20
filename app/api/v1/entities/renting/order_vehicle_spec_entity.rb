# frozen_string_literal: true

module V1
  module Entities
    module Renting
      class OrderVehicleSpecEntity < Grape::Entity
        expose :id
        expose :vehicle_type, using: VehicleTypeEntity
        expose :fuel_type
        expose :transmission
        expose :environmental_label
        expose :min_seats
        expose :preferred_color
        expose :additional_equipment
      end
    end
  end
end
