# frozen_string_literal: true

module Renting
  module Contracts
    class Terminator
      attr_reader :errors, :contract

      def initialize(contract, termination_params, current_user)
        @contract = contract
        @params = termination_params
        @current_user = current_user
        @errors = []
      end

      def call
        ActiveRecord::Base.transaction do
          update_termination_data
          handle_end_action

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

      def update_termination_data
        @contract.update!(
          termination_type: @params[:termination_type],
          end_action: @params[:end_action],
          termination_request_date: @params[:termination_request_date] || Date.current
        )
      end

      def handle_end_action
        if @contract.end_action == "return_vehicle"
          create_vehicle_return
          initiate_vehicle_return_state
        elsif @contract.end_action == "purchase_vehicle"
          # Si hay compra, pasamos directo a pending_closure
          @contract.initiate_closure!
        end
      end

      def create_vehicle_return
        Renting::VehicleReturn.create!(
          vehicle: @contract.vehicle,
          contract: @contract
          # status inicial por AASM: pending_scheduling
        )
      end

      def initiate_vehicle_return_state
        # El vehículo pasa a estado de "pendiente de devolución"
        # Asumiendo que tenemos el evento initiate_return! en Vehicle (según conversación previa)
        @contract.vehicle.initiate_return!
      end
    end
  end
end
