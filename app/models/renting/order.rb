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

    # Authorization integration (transversal system)
    has_one :authorization_request, as: :authorizable, dependent: :destroy

    # Enums
    enum :status, {
      created: "created",
      pending_authorization: "pending_authorization",
      authorized: "authorized",
      rejected: "rejected",
      pending_supplier_confirmation: "pending_supplier_confirmation",
      confirmed: "confirmed",
      vehicle_assigned: "vehicle_assigned",
      completed: "completed",
      cancelled: "cancelled"
    }, default: "created"

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
