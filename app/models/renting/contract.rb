# frozen_string_literal: true

module Renting
  class Contract < ApplicationRecord
    self.table_name = "renting_contracts"

    # Associations
    belongs_to :order, class_name: "Renting::Order"
    belongs_to :vehicle, class_name: "Renting::Vehicle"
    belongs_to :supplier
    belongs_to :company

    # Enums
    enum :status, {
      pending_formalization: "pending_formalization",
      pending_signature: "pending_signature",
      active: "active",
      suspended: "suspended",
      completed: "completed",
      cancelled: "cancelled"
    }, default: "pending_formalization"

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

    def calculate_expected_end_date
      if start_date.present? && duration_months.present?
        self.expected_end_date = start_date + duration_months.months
      end
    end
  end
end
