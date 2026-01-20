# frozen_string_literal: true

module Renting
  module Orders
    class StateMachine
      TRANSITIONS = {
        "created" => [ "pending_authorization", "cancelled" ],
        "pending_authorization" => [ "authorized", "rejected", "cancelled" ],
        "authorized" => [ "pending_supplier_confirmation", "cancelled" ],
        "rejected" => [],
        "pending_supplier_confirmation" => [ "confirmed", "cancelled" ],
        "confirmed" => [ "vehicle_assigned", "cancelled" ],
        "vehicle_assigned" => [ "completed", "cancelled" ],
        "completed" => [],
        "cancelled" => []
      }.freeze

      def initialize(order, current_user)
        @order = order
        @current_user = current_user
      end

      def can_transition_to?(new_status)
        allowed_transitions.include?(new_status)
      end

      def transition_to!(new_status, notes: nil)
        unless can_transition_to?(new_status)
          raise "Invalid transition from #{@order.status} to #{new_status}"
        end

        old_status = @order.status
        @order.update!(status: new_status)

        record_status_change(old_status, new_status, notes)
      end

      def allowed_transitions
        TRANSITIONS[@order.status] || []
      end

      private

      def record_status_change(from_status, to_status, notes)
        Renting::OrderStatusHistory.create!(
          order: @order,
          from_status: from_status,
          to_status: to_status,
          changed_by: @current_user,
          changed_at: Time.current,
          notes: notes
        )
      end
    end
  end
end
