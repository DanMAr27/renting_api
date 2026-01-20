# frozen_string_literal: true

module Renting
  class Order < ApplicationRecord
    self.table_name = "renting_orders"

    # Associations
    belongs_to :order_series, class_name: "Renting::OrderSeries"
    belongs_to :company
    belongs_to :supplier
    belongs_to :created_by, class_name: "User"
    belongs_to :old_vehicle, class_name: "Renting::Vehicle", optional: true

    has_one :vehicle_spec, class_name: "Renting::OrderVehicleSpec", dependent: :destroy
    has_one :contract_condition, class_name: "Renting::OrderContractCondition", dependent: :destroy
    has_one :assignment, class_name: "Renting::OrderAssignment", dependent: :destroy
    has_many :order_services, class_name: "Renting::OrderService", dependent: :destroy
    has_many :services, through: :order_services, class_name: "Renting::Service"
    has_many :status_histories, class_name: "Renting::OrderStatusHistory", dependent: :destroy
    has_many :delivery_histories, class_name: "Renting::OrderDeliveryHistory", dependent: :destroy

    # Post-delivery associations
    has_one :vehicle, class_name: "Renting::Vehicle", dependent: :destroy
    has_one :contract, class_name: "Renting::Contract", dependent: :destroy
    has_many :vehicle_deliveries, class_name: "Renting::VehicleDelivery", dependent: :destroy

    # Authorization integration (transversal system)
    has_one :authorization_request, as: :authorizable, dependent: :destroy

    # Enums
    # AASM State Machine
    include AASM

    aasm column: :status, no_direct_assignment: true do
      state :created, initial: true
      state :pending_authorization
      state :authorized
      state :rejected
      state :pending_supplier_confirmation
      state :confirmed
      state :finished
      state :cancelled

      event :submit_authorization do
        transitions from: :created, to: :pending_authorization
      end

      event :authorize do
        transitions from: :pending_authorization, to: :authorized
      end

      event :reject do
        transitions from: :pending_authorization, to: :rejected
      end

      event :send_to_supplier do
        transitions from: :authorized, to: :pending_supplier_confirmation
      end

      event :confirm_by_supplier do
        transitions from: :pending_supplier_confirmation, to: :confirmed
      end

      event :complete do
        transitions from: :confirmed, to: :finished
      end

      event :cancel do
        transitions from: %i[created pending_authorization authorized pending_supplier_confirmation confirmed], to: :cancelled
      end
    end

    # Validations
    validates :order_number, presence: true, uniqueness: true
    validates :status, presence: true
    validates :order_date, presence: true

    # Scopes
    scope :active, -> { where.not(status: "cancelled") }
    scope :by_status, ->(status) { where(status: status) }
    scope :recent, -> { order(created_at: :desc) }

    # Delegations
    delegate :status, to: :authorization_request, prefix: :authorization, allow_nil: true

    # Defaults
    after_initialize :set_defaults, if: :new_record?

    private

    def set_defaults
      self.order_date ||= Date.current
      self.is_renewal ||= false
    end
  end
end
