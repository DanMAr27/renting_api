# frozen_string_literal: true

module Renting
  class OrderVehicleSpec < ApplicationRecord
    self.table_name = "renting_order_vehicle_specs"

    # Associations
    belongs_to :order, class_name: "Renting::Order"
    belongs_to :vehicle_type, class_name: "Renting::VehicleType"

    # Enums
    enum :fuel_type, {
      gasoline: "gasoline",
      diesel: "diesel",
      electric: "electric",
      hybrid: "hybrid",
      plugin_hybrid: "plugin_hybrid"
    }

    enum :transmission, {
      manual: "manual",
      automatic: "automatic"
    }

    # Validations
    validates :vehicle_type_id, presence: true
    validates :fuel_type, presence: true
    validates :transmission, presence: true
    validates :min_seats, presence: true, numericality: { only_integer: true, greater_than: 0 }
  end
end
