# frozen_string_literal: true

module Renting
  class Service < ApplicationRecord
    self.table_name = "services"

    # Validations
    validates :code, presence: true, uniqueness: true
    validates :name, presence: true

    # Scopes
    scope :active, -> { where(active: true) }

    # Defaults
    after_initialize :set_defaults, if: :new_record?

    private

    def set_defaults
      self.active = true if active.nil?
    end
  end
end
