# frozen_string_literal: true

module Renting
  module Orders
    class NumberGenerator
      def initialize(order_series)
        @order_series = order_series
      end

      def generate
        @order_series.next_number!
      end
    end
  end
end
