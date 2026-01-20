# frozen_string_literal: true

module Renting
  class Vehicle < ApplicationRecord
    include AvailableActions
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

    # AvailableActions implementation
    def available_action_buttons
      actions = []

      case status
      when "pending_delivery"
        if delivery.present?
          case delivery.status
          when "pending_scheduling"
            actions << { name: "schedule_delivery", label: "Programar Entrega", endpoint: "POST /api/v1/renting/vehicles/#{id}/delivery/schedule", primary: true }
          when "scheduled"
            actions << { name: "confirm_delivery", label: "Confirmar Entrega", endpoint: "POST /api/v1/renting/vehicles/#{id}/delivery/confirm", primary: true }
            actions << { name: "reschedule_delivery", label: "Reprogramar", endpoint: "POST /api/v1/renting/vehicles/#{id}/delivery/schedule" }
          end
        end
      when "active"
        actions << { name: "immobilize", label: "Inmovilizar", endpoint: "POST /api/v1/renting/vehicles/#{id}/immobilize" }
        actions << { name: "initiate_return", label: "Iniciar Devolución", endpoint: "POST /api/v1/renting/vehicles/#{id}/return/initiate", primary: true }
      when "immobilized"
        actions << { name: "reactivate", label: "Reactivar", endpoint: "POST /api/v1/renting/vehicles/#{id}/reactivate", primary: true }
      when "pending_return"
        if vehicle_return.present?
          case vehicle_return.status
          when "pending_scheduling"
            actions << { name: "schedule_return", label: "Programar Devolución", endpoint: "POST /api/v1/renting/vehicles/#{id}/return/schedule", primary: true }
          when "scheduled"
            actions << { name: "confirm_return", label: "Confirmar Devolución", endpoint: "POST /api/v1/renting/vehicles/#{id}/return/confirm", primary: true }
            actions << { name: "reschedule_return", label: "Reprogramar", endpoint: "POST /api/v1/renting/vehicles/#{id}/return/schedule" }
          end
          actions << { name: "cancel_return", label: "Cancelar Devolución", endpoint: "POST /api/v1/renting/vehicles/#{id}/return/cancel", destructive: true }
        end
      end

      actions
    end

    def related_entity_actions
      result = {}

      if delivery.present?
        result[:delivery] = {
          id: delivery.id,
          status: delivery.status,
          scheduled_date: delivery.scheduled_date,
          scheduled_location: delivery.scheduled_location
        }
      end

      if vehicle_return.present?
        result[:return] = {
          id: vehicle_return.id,
          status: vehicle_return.status,
          scheduled_date: vehicle_return.scheduled_date,
          scheduled_location: vehicle_return.scheduled_location
        }
      end

      if contract.present?
        result[:contract] = {
          id: contract.id,
          status: contract.status
        }
      end

      result
    end

    def set_defaults
      self.current_km ||= initial_km if initial_km.present?
    end
  end
end
