# frozen_string_literal: true

module Renting
  class Contract < ApplicationRecord
    include AvailableActions
    self.table_name = "renting_contracts"

    # Associations
    belongs_to :order, class_name: "Renting::Order"
    belongs_to :vehicle, class_name: "Renting::Vehicle"
    belongs_to :supplier
    belongs_to :company

    has_one :vehicle_return, class_name: "Renting::VehicleReturn"

    # Enums
    enum :termination_type, {
      expiration: "expiration",
      early: "early"
    }

    enum :end_action, {
      return_vehicle: "return_vehicle",
      purchase_vehicle: "purchase_vehicle"
    }

    # AASM State Machine
    include AASM

    aasm column: :status, no_direct_assignment: true do
      state :pending_signature, initial: true
      state :active
      state :pending_closure
      state :finalized

      # pending_signature -> active
      event :activate do
        transitions from: :pending_signature, to: :active
      end

      # active -> pending_closure
      event :initiate_closure do
        transitions from: :active, to: :pending_closure
      end

      # pending_closure -> finalized
      event :finalize do
        transitions from: :pending_closure, to: :finalized
      end
    end

    # Validations
    validates :duration_months, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :annual_km, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :monthly_fee, presence: true, numericality: { greater_than: 0 }

    # Scopes
    scope :active, -> { where(status: "active") }
    scope :expiring_soon, ->(days = 30) { where("expected_end_date <= ?", Date.current + days.days).where(status: "active") }
    scope :recent, -> { order(start_date: :desc) }

    # Callbacks
    before_save :calculate_expected_end_date, if: -> { start_date.present? }

    # Methods
    def days_until_expiration
      return nil unless expected_end_date
      (expected_end_date - Date.current).to_i
    end

    private

    # AvailableActions implementation
    def available_action_buttons
      actions = []

      case status
      when "pending_signature"
        if vehicle&.active?
          actions << { name: "activate", label: "Activar Contrato", endpoint: "POST /api/v1/renting/contracts/#{id}/activate", primary: true }
        end
      when "active"
        actions << { name: "initiate_termination", label: "Iniciar Terminación", endpoint: "POST /api/v1/renting/contracts/#{id}/terminate", primary: true }
      when "pending_closure"
        if vehicle_return.present?
          case vehicle_return.status
          when "pending_scheduling"
            actions << { name: "schedule_return", label: "Programar Devolución", endpoint: "POST /api/v1/renting/contracts/#{id}/return/schedule", primary: true }
          when "scheduled"
            actions << { name: "confirm_return", label: "Confirmar Devolución", endpoint: "POST /api/v1/renting/contracts/#{id}/return/confirm", primary: true }
          end
        end
        actions << { name: "finalize", label: "Finalizar Contrato", endpoint: "POST /api/v1/renting/contracts/#{id}/finalize", primary: true }
      end

      actions
    end

    def related_entity_actions
      result = {}

      if vehicle.present?
        result[:vehicle] = {
          id: vehicle.id,
          status: vehicle.status,
          license_plate: vehicle.license_plate
        }
      end

      if vehicle_return.present?
        result[:return] = {
          id: vehicle_return.id,
          status: vehicle_return.status,
          scheduled_date: vehicle_return.scheduled_date
        }
      end

      result
    end

    def calculate_expected_end_date
      if start_date.present? && duration_months.present?
        self.expected_end_date = start_date + duration_months.months
      end
    end
  end
end
