# frozen_string_literal: true

class AuthorizationRequest < ApplicationRecord
  # Polymorphic association
  belongs_to :authorizable, polymorphic: true
  belongs_to :requested_by, class_name: "User"
  has_many :approvals, class_name: "AuthorizationApproval", dependent: :destroy

  # Enums
  enum :status, {
    pending: "pending",
    approved: "approved",
    rejected: "rejected",
    cancelled: "cancelled"
  }, default: "pending"

  # Validations
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :current_level, :max_level, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # Scopes
  scope :pending, -> { where(status: "pending") }
  scope :completed, -> { where.not(status: "pending") }
  scope :recent, -> { order(created_at: :desc) }

  # Methods
  def pending_approvers
    # Retorna usuarios que pueden aprobar el nivel actual
    User.where(role: required_role_for_current_level)
  end

  def can_approve?(user)
    pending? && user.role == required_role_for_current_level
  end

  def fully_approved?
    current_level >= max_level
  end

  def next_level!
    increment!(:current_level)
  end

  def complete_approval!
    update!(status: "approved", completed_at: Time.current)
  end

  def complete_rejection!
    update!(status: "rejected", completed_at: Time.current)
  end

  private

  def required_role_for_current_level
    rule = AuthorizationRule.active
                            .for_type(authorizable_type)
                            .find_by(approval_level: current_level)
    rule&.required_role || "admin"
  end
end
