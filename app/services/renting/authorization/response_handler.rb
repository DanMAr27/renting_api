# frozen_string_literal: true

module Renting
  module Authorization
    class ResponseHandler
      def initialize(order)
        @order = order
      end

      def handle_approval
        @order.update!(status: "authorized")

        record_status_change("pending_authorization", "authorized", "Authorization approved")
      end

      def handle_rejection(reason = nil)
        @order.update!(status: "rejected")

        record_status_change("pending_authorization", "rejected", reason || "Authorization rejected")
      end

      private

      def record_status_change(from_status, to_status, notes)
        Renting::OrderStatusHistory.create!(
          order: @order,
          from_status: from_status,
          to_status: to_status,
          changed_by: @order.created_by, # TODO: Should be the approver
          changed_at: Time.current,
          notes: notes
        )
      end
    end
  end
end
