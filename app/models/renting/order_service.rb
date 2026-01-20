# frozen_string_literal: true

module Renting
  class OrderService < ApplicationRecord
    self.table_name = "renting_order_services"

    # Associations
    belongs_to :order, class_name: "Renting::Order"
    belongs_to :service, class_name: "Renting::Service"

    # Validations
    validates :service_id, uniqueness: { scope: :order_id }
    validates :monthly_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  end
end
