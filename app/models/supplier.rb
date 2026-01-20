# frozen_string_literal: true

class Supplier < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  # Scopes
  scope :active, -> { where(active: true) }

  # Defaults
  after_initialize :set_defaults, if: :new_record?

  private

  def set_defaults
    self.active = true if active.nil?
  end
end
