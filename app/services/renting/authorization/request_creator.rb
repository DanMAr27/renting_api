# frozen_string_literal: true

module Renting
  module Authorization
    class RequestCreator
      def initialize(order)
        @order = order
      end

      def call
        # Use the transversal authorization system
        auth_request = ::Authorization::RequestCreator.new(@order, @order.created_by).call

        if auth_request
          @order.update!(status: "pending_authorization")
          record_status_change
        else
          # No authorization required, auto-approve
          @order.update!(status: "authorized")
          record_status_change("created", "authorized", "Auto-approved (no authorization required)")
        end

        auth_request
      end

      private

      def record_status_change(from_status = "created", to_status = "pending_authorization", notes = "Authorization requested")
        Renting::OrderStatusHistory.create!(
          order: @order,
          from_status: from_status,
          to_status: to_status,
          changed_by: @order.created_by,
          changed_at: Time.current,
          notes: notes
        )
      end
    end
  end
end
