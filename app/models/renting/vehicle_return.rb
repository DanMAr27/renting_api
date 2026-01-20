# frozen_string_literal: true

module Renting
  class VehicleReturn < ApplicationRecord
    self.table_name = "renting_vehicle_returns"

    # Associations
    belongs_to :vehicle, class_name: "Renting::Vehicle"
    belongs_to :contract, class_name: "Renting::Contract"
    belongs_to :scheduled_by, class_name: "User", optional: true
    belongs_to :confirmed_by, class_name: "User", optional: true

    # AASM State Machine
    include AASM

    aasm column: :status, no_direct_assignment: true do
      state :pending_scheduling, initial: true
      state :scheduled
      state :confirmed
      state :cancelled

      event :schedule do
        transitions from: :pending_scheduling, to: :scheduled
      end

      event :reschedule do
        transitions from: :scheduled, to: :scheduled
      end

      event :confirm do
        transitions from: [ :pending_scheduling, :scheduled ], to: :confirmed
      end

      event :cancel do
        transitions from: [ :pending_scheduling, :scheduled ], to: :cancelled
      end
    end

    # Validations
    validates :scheduled_date, presence: true, if: -> { scheduled? || scheduling? }
    validates :scheduled_location, presence: true, if: -> { scheduled? || scheduling? }
    validates :scheduled_by_id, presence: true, if: -> { scheduled? }

    validates :actual_return_date, presence: true, if: -> { confirmed? || confirming? }
    validates :final_km, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: -> { confirmed? || confirming? }
    validates :confirmed_by_id, presence: true, if: -> { confirmed? }
    validates :confirmed_at, presence: true, if: -> { confirmed? }

    # Callbacks
    before_validation :set_scheduled_at, if: -> { scheduling? }
    before_validation :set_confirmed_at, if: -> { confirming? }

    private

    def scheduling?
      status_changed? && status == "scheduled"
    end

    def confirming?
      status_changed? && status == "confirmed"
    end

    def set_scheduled_at
      self.scheduled_at ||= Time.current
    end

    def set_confirmed_at
      self.confirmed_at ||= Time.current
    end
  end
end
