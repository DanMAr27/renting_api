# frozen_string_literal: true

module Renting
  class OrderAssignment < ApplicationRecord
    self.table_name = "renting_order_assignments"

    # Associations
    belongs_to :order, class_name: "Renting::Order"
    belongs_to :driver, class_name: "User", optional: true
    belongs_to :cost_center, optional: true
    belongs_to :department, optional: true
    belongs_to :division, optional: true

    # Enums
    enum :usage_type, {
      individual: "individual",
      collective: "collective"
    }

    # Validations
    validates :usage_type, presence: true
    validate :driver_required_for_individual_usage

    private

    def driver_required_for_individual_usage
      if usage_type == "individual" && driver_id.blank?
        errors.add(:driver_id, "must be present for individual usage")
      end
    end
  end
end
