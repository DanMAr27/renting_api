# frozen_string_literal: true

class Company < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :tax_id, presence: true, uniqueness: true

  # Scopes
  scope :active, -> { where(active: true) }

  # Defaults
  after_initialize :set_defaults, if: :new_record?

  private

  def set_defaults
    self.active = true if active.nil?
  end
end
