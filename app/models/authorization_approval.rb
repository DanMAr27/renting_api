# frozen_string_literal: true

class AuthorizationApproval < ApplicationRecord
  belongs_to :authorization_request
  belongs_to :approver, class_name: "User"

  # Enums
  enum :action, {
    approved: "approved",
    rejected: "rejected"
  }

  # Validations
  validates :approval_level, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :action, presence: true

  # Callbacks
  before_create :set_approved_at

  # Scopes
  scope :approved, -> { where(action: "approved") }
  scope :rejected, -> { where(action: "rejected") }
  scope :by_level, -> { order(:approval_level) }

  private

  def set_approved_at
    self.approved_at = Time.current
  end
end
