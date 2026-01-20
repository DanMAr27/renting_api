# frozen_string_literal: true

module Renting
  class Vehicle < ApplicationRecord
    self.table_name = "renting_vehicles"

    # Associations
    belongs_to :order, class_name: "Renting::Order"
    belongs_to :vehicle_type, class_name: "Renting::VehicleType"
    has_one :contract, class_name: "Renting::Contract", dependent: :destroy

    # Enums
    enum :status, {
      pending_delivery: "pending_delivery",
      in_transit: "in_transit",
      active: "active",
      in_maintenance: "in_maintenance",
      pending_return: "pending_return",
      returned: "returned"
    }, default: "pending_delivery"

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

    # Validations (conditional for pending states)
    validates :license_plate, presence: true, uniqueness: true, if: -> { active? || in_maintenance? || pending_return? || returned? }
    validates :vin, presence: true, uniqueness: true, if: -> { active? || in_maintenance? || pending_return? || returned? }
    validates :delivery_date, presence: true, if: -> { active? || in_maintenance? || pending_return? || returned? }
    validates :initial_km, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, if: -> { active? || in_maintenance? || pending_return? || returned? }
    validates :current_km, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, if: -> { active? || in_maintenance? || pending_return? || returned? }

    # Scopes
    scope :active, -> { where(status: "active") }
    scope :recent, -> { order(delivery_date: :desc) }

    # Methods
    def update_km(new_km)
      update!(current_km: new_km) if new_km > current_km
    end

    # Defaults
    after_initialize :set_defaults, if: :new_record?

    private

    def set_defaults
      self.current_km ||= initial_km if initial_km.present?
    end
  end
end
