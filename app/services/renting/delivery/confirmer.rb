# frozen_string_literal: true

module Renting
  module Delivery
    class Confirmer
      attr_reader :errors, :delivery

      def initialize(vehicle_delivery, confirmation_params, current_user)
        @delivery = vehicle_delivery
        @params = confirmation_params
        @current_user = current_user
        @errors = []
      end

      def call
        ActiveRecord::Base.transaction do
          update_vehicle_data
          update_contract_data
          transition_vehicle_and_contract
          confirm_delivery
          update_order_status

          true
        rescue ActiveRecord::RecordInvalid, AASM::InvalidTransition => e
          @errors << e.message
          raise ActiveRecord::Rollback
        end
      end

      def success?
        @errors.empty?
      end

      private

      def update_vehicle_data
        @delivery.vehicle.update!(
          license_plate: @params[:license_plate],
          vin: @params[:vin],
          initial_km: @params[:initial_km],
          current_km: @params[:initial_km],
          color: @params[:color].presence || @delivery.vehicle.color,
          delivery_date: @params[:actual_delivery_date]
        )
      end

      def update_contract_data
        @delivery.vehicle.contract.update!(
          supplier_contract_number: @params[:supplier_contract_number],
          start_date: @params[:contract_start_date]
        )
      end

      def transition_vehicle_and_contract
        @delivery.vehicle.deliver!           # pending_delivery -> active
        @delivery.vehicle.contract.activate! # pending_signature -> active
      end

      def confirm_delivery
        @delivery.update!(
          confirmed_by: @current_user,
          confirmed_at: Time.current,
          confirmation_notes: @params[:confirmation_notes]
        )
        @delivery.confirm! # pending/scheduled -> confirmed
      end

      def update_order_status
        # Note: Depending on business logic, we might check if all vehicles in order are delivered before completing the order
        # For now, we assume 1 vehicle per order loop logic or verify if this transitions the order

        # We only update order status if it's the last/only vehicle or if business logic dictates
        state_machine = Renting::Orders::StateMachine.new(@delivery.order, @current_user)

        # Check if we can transition to finished or completed
        # Assuming order has state 'finished' or similar
        # If the order is confirmed, we might want to move it to 'finished' if all vehicles are delivered
        # But per current logic in Completer service: transition_to!("completed") which is not in AASM states of Order?
        # Checking Order model AASM states: created, pending_auth, authorized, rejected, pending_supplier, confirmed, finished, cancelled
        # Completer previously used "completed", but AASM has "finished" from "confirmed".
        # Let's align with Order AASM: confirmed -> finished (event: complete)

        if state_machine.can_transition_to?(:finished)
           state_machine.transition_to!(:finished, notes: "Vehicle delivered and contract activated")
        end
      end
    end
  end
end
