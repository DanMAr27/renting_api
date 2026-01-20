# frozen_string_literal: true

module Renting
  module Orders
    class VehicleAssigner
      attr_reader :errors, :vehicle, :contract

      def initialize(order)
        @order = order
        @errors = []
      end

      def call
        ActiveRecord::Base.transaction do
          create_vehicle
          create_contract
          update_order_status

          true
        rescue ActiveRecord::RecordInvalid => e
          @errors << e.message
          raise ActiveRecord::Rollback
        end
      end

      def success?
        @errors.empty? && @vehicle.present? && @contract.present?
      end

      private

      def create_vehicle
        @vehicle = Renting::Vehicle.create!(
          order: @order,
          vehicle_type: @order.vehicle_spec.vehicle_type,
          fuel_type: @order.vehicle_spec.fuel_type,
          transmission: @order.vehicle_spec.transmission,
          status: "pending_delivery"
          # NO incluir: license_plate, vin, color, delivery_date, initial_km
          # Estos se añaden cuando se completa la entrega
        )
      end

      def create_contract
        @contract = Renting::Contract.create!(
          order: @order,
          vehicle: @vehicle,
          supplier: @order.supplier,
          company: @order.company,
          duration_months: @order.contract_condition.duration_months,
          annual_km: @order.contract_condition.annual_km,
          monthly_fee: @order.contract_condition.monthly_fee,
          status: "pending_formalization"
          # NO incluir: supplier_contract_number, start_date
          # Estos se añaden cuando se completa la entrega
        )
      end

      def update_order_status
        state_machine = Renting::Orders::StateMachine.new(@order, @order.created_by)
        state_machine.transition_to!("vehicle_assigned", notes: "Vehicle and contract created, pending delivery")
      end
    end
  end
end
