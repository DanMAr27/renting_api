# frozen_string_literal: true

class User < ApplicationRecord
  # Enums
  enum :role, { user: "user", manager: "manager", admin: "admin" }


  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :role, presence: true

  # Scopes
  scope :active, -> { where(active: true) }

  # Defaults
  after_initialize :set_defaults, if: :new_record?

  private

  def set_defaults
    self.active = true if active.nil?
    self.role ||= "user"
  end
end
