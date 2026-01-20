# frozen_string_literal: true

module Renting
  module Delivery
    class Completer
      attr_reader :errors

      def initialize(vehicle, delivery_params)
        @vehicle = vehicle
        @params = delivery_params
        @errors = []
      end

      def call
        ActiveRecord::Base.transaction do
          update_vehicle
          update_contract
          update_order_status

          true
        rescue ActiveRecord::RecordInvalid => e
          @errors << e.message
          raise ActiveRecord::Rollback
        end
      end

      def success?
        @errors.empty?
      end

      private

      def update_vehicle
        @vehicle.update!(
          license_plate: @params[:license_plate],
          vin: @params[:vin],
          color: @params[:color] || @vehicle.order.vehicle_spec.preferred_color,
          delivery_date: @params[:delivery_date] || Date.current,
          initial_km: @params[:initial_km],
          current_km: @params[:initial_km],
          status: "active"
        )
      end

      def update_contract
        @vehicle.contract.update!(
          supplier_contract_number: @params[:supplier_contract_number],
          start_date: @params[:contract_start_date] || Date.current,
          status: "active"
        )
      end

      def update_order_status
        state_machine = Renting::Orders::StateMachine.new(@vehicle.order, @vehicle.order.created_by)
        state_machine.transition_to!("completed", notes: "Vehicle delivered and contract activated")
      end
    end
  end
end
