# frozen_string_literal: true

module Renting
  class OrderContractCondition < ApplicationRecord
    self.table_name = "renting_order_contract_conditions"

    # Associations
    belongs_to :order, class_name: "Renting::Order"

    # Validations
    validates :duration_months, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :annual_km, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :monthly_fee, presence: true, numericality: { greater_than: 0 }

    # Callbacks
    before_save :calculate_contract_end_date

    private

    def calculate_contract_end_date
      if contract_start_date.present? && duration_months.present?
        self.contract_end_date = contract_start_date + duration_months.months
      end
    end
  end
end
