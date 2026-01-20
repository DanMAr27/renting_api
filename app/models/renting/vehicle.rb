# frozen_string_literal: true

module Renting
  class Vehicle < ApplicationRecord
    self.table_name = "renting_vehicles"

    # Associations
    belongs_to :order, class_name: "Renting::Order"
    belongs_to :vehicle_type, class_name: "Renting::VehicleType"
    has_one :contract, class_name: "Renting::Contract", dependent: :destroy
    has_one :delivery, class_name: "Renting::VehicleDelivery", dependent: :destroy
    has_one :vehicle_return, class_name: "Renting::VehicleReturn", dependent: :destroy

    # AASM State Machine
    include AASM

    aasm column: :status, no_direct_assignment: true do
      state :pending_delivery, initial: true
      state :active
      state :immobilized
      state :pending_return
      state :inactive

      # pending_delivery -> active
      event :deliver do
        transitions from: :pending_delivery, to: :active
      end

      # active <-> immobilized
      event :immobilize do
        transitions from: :active, to: :immobilized
      end

      event :reactivate do
        transitions from: :immobilized, to: :active
      end

      # active -> pending_return
      event :initiate_return do
        transitions from: :active, to: :pending_return
      end

      # pending_return -> active
      event :cancel_return do
        transitions from: :pending_return, to: :active
      end

      # pending_return -> inactive
      event :complete_return do
        transitions from: :pending_return, to: :inactive
      end
    end

    # Enums (mantener para fuel_type y transmission)
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

    # Validations (actualizar para nuevos estados)
    validates :license_plate, presence: true, uniqueness: true,
              if: -> { active? || immobilized? || pending_return? || inactive? }
    validates :vin, presence: true, uniqueness: true,
              if: -> { active? || immobilized? || pending_return? || inactive? }
    validates :delivery_date, presence: true,
              if: -> { active? || immobilized? || pending_return? || inactive? }
    validates :initial_km, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 },
              if: -> { active? || immobilized? || pending_return? || inactive? }
    validates :current_km, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 },
              if: -> { active? || immobilized? || pending_return? || inactive? }

    # Scopes
    scope :active, -> { where(status: "active") }
    scope :operational, -> { where(status: [ "active", "immobilized" ]) }
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
