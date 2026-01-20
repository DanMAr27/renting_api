# frozen_string_literal: true

module Renting
  class OrderDeliveryHistory < ApplicationRecord
    self.table_name = "renting_order_delivery_histories"

    # Associations
    belongs_to :order, class_name: "Renting::Order"
    belongs_to :registered_by, class_name: "User"

    # Enums
    enum :event_type, {
      initial_forecast: "initial_forecast",
      rescheduled: "rescheduled",
      confirmed: "confirmed"
    }

    # Validations
    validates :event_type, presence: true
    validates :scheduled_date, presence: true

    # Scopes
    scope :recent, -> { order(created_at: :desc) }
  end
end
