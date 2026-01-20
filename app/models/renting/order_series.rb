# frozen_string_literal: true

module Renting
  class OrderSeries < ApplicationRecord
    self.table_name = "order_series"

    # Validations
    validates :code, presence: true, uniqueness: true
    validates :prefix, presence: true
    validates :current_counter, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    # Scopes
    scope :active, -> { where(active: true) }

    # Defaults
    after_initialize :set_defaults, if: :new_record?

    # Methods
    def next_number!
      transaction do
        lock!
        self.current_counter += 1
        save!
        format_number
      end
    end

    private

    def set_defaults
      self.active = true if active.nil?
      self.current_counter ||= 0
    end

    def format_number
      "#{prefix}-#{Time.current.year}-#{current_counter.to_s.rjust(4, '0')}"
    end
  end
end
