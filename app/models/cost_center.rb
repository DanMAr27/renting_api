# frozen_string_literal: true

class CostCenter < ApplicationRecord
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
