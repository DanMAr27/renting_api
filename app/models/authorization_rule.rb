# frozen_string_literal: true

class AuthorizationRule < ApplicationRecord
  # Enums
  enum :condition_operator, {
    greater_than: ">",
    less_than: "<",
    greater_or_equal: ">=",
    less_or_equal: "<=",
    equal: "==",
    not_equal: "!="
  }, prefix: :operator

  # Validations
  validates :authorizable_type, presence: true
  validates :name, presence: true
  validates :required_role, presence: true
  validates :approval_level, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # Scopes
  scope :active, -> { where(active: true) }
  scope :for_type, ->(type) { where(authorizable_type: type) }
  scope :by_level, -> { order(:approval_level) }

  # Methods
  def matches?(authorizable)
    return true if condition_field.blank?

    value = extract_value(authorizable)
    evaluate_condition(value)
  end

  private

  def extract_value(authorizable)
    # Navigate nested attributes if needed (e.g., "contract_condition.monthly_fee")
    fields = condition_field.split(".")
    value = authorizable

    fields.each do |field|
      value = value.send(field)
      return nil if value.nil?
    end

    value
  end

  def evaluate_condition(value)
    return false if value.nil? || condition_value.nil?

    case condition_operator
    when "greater_than" then value > condition_value
    when "less_than" then value < condition_value
    when "greater_or_equal" then value >= condition_value
    when "less_or_equal" then value <= condition_value
    when "equal" then value == condition_value
    when "not_equal" then value != condition_value
    else false
    end
  end
end
