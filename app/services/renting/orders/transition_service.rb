# frozen_string_literal: true

module Renting
  module Orders
    class TransitionService
      def call(order:, event:, user:)
        # Ensure the event is valid before starting the transaction
        unless order.aasm.may_fire_event?(event)
          raise AASM::InvalidTransition.new(order, event)
        end

        ActiveRecord::Base.transaction do
          from_status = order.status

          # Fire the event. Using the bang method (!) to persist the change.
          order.public_send("#{event}!")

          to_status = order.status

          # Create the history record
          Renting::OrderStatusHistory.create!(
            order: order,
            from_status: from_status,
            to_status: to_status,
            changed_by: user,
            changed_at: Time.current
          )
        end

        # Return true or the order itself to indicate success
        order
      end
    end
  end
end
