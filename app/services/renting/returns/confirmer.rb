# frozen_string_literal: true

module Renting
  module Returns
    class Confirmer
      attr_reader :errors, :vehicle_return

      def initialize(vehicle_return, confirmation_params, current_user)
        @vehicle_return = vehicle_return
        @params = confirmation_params
        @current_user = current_user
        @errors = []
      end

      def call
        ActiveRecord::Base.transaction do
          update_return_data
          update_vehicle_data
          close_vehicle_process
          update_contract_status
          transition_return_status

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

      def update_return_data
         @vehicle_return.update!(
           actual_return_date: @params[:actual_return_date],
           final_km: @params[:final_km],
           return_notes: @params[:return_notes],
           confirmed_by: @current_user,
           confirmed_at: Time.current
         )
      end

      def update_vehicle_data
        # Actualizamos km del vehículo
        @vehicle_return.vehicle.update!(
          current_km: @params[:final_km]
        )
      end

      def close_vehicle_process
        # El vehículo pasa a estado inactivo (devuelto a flota inactiva o similar)
        # Asumiendo evento complete_return! en Vehicle
        @vehicle_return.vehicle.complete_return!
      end

      def update_contract_status
        # Al devolver el coche, el contrato pasa a pendiente de cierre (liquidación)
        contract = @vehicle_return.contract
        contract.initiate_closure! if contract.active? # Solo si no estaba ya en ese estado
      end

      def transition_return_status
        @vehicle_return.confirm!
      end
    end
  end
end
