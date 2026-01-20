# frozen_string_literal: true

module Renting
  module Authorization
    class Policy
      def initialize(order)
        @order = order
      end

      def requires_authorization?
        # For PoC: simple rule based on monthly fee
        # In production, this would query AuthorizationRule
        return false if @order.contract_condition.nil?

        @order.contract_condition.monthly_fee > 500
      end
    end
  end
end
