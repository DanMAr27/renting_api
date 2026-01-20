# frozen_string_literal: true

module Renting
  class OrderStatusHistory < ApplicationRecord
    self.table_name = "renting_order_status_histories"

    # Associations
    belongs_to :order, class_name: "Renting::Order"
    belongs_to :changed_by, class_name: "User"

    # Validations
    validates :from_status, presence: true
    validates :to_status, presence: true
    validates :changed_at, presence: true

    # Scopes
    scope :recent, -> { order(changed_at: :desc) }

    # Defaults
    after_initialize :set_defaults, if: :new_record?

    private

    def set_defaults
      self.changed_at ||= Time.current
    end
  end
end
