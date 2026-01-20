# frozen_string_literal: true

module Renting
  module Returns
    class Scheduler
      attr_reader :errors, :vehicle_return

      def initialize(vehicle_return, scheduling_params, current_user)
        @vehicle_return = vehicle_return
        @params = scheduling_params
        @current_user = current_user
        @errors = []
      end

      def call
        ActiveRecord::Base.transaction do
          update_scheduling_data
          transition_to_scheduled

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

      def update_scheduling_data
        if @vehicle_return.scheduled? && scheduling_changed?
          @vehicle_return.reschedule_count += 1
        end

        @vehicle_return.update!(
          scheduled_date: @params[:scheduled_date],
          scheduled_time: @params[:scheduled_time],
          scheduled_location: @params[:scheduled_location],
          scheduling_notes: @params[:scheduling_notes],
          scheduled_by: @current_user,
          scheduled_at: Time.current
        )
      end

      def transition_to_scheduled
        if @vehicle_return.pending_scheduling?
          @vehicle_return.schedule!
        elsif @vehicle_return.scheduled?
          @vehicle_return.reschedule!
        else
          raise AASM::InvalidTransition.new(@vehicle_return, :schedule, @vehicle_return.status)
        end
      end

      def scheduling_changed?
        @vehicle_return.scheduled_date_was != @params[:scheduled_date] ||
          @vehicle_return.scheduled_time_was&.strftime("%H:%M") != @params[:scheduled_time]&.strftime("%H:%M") ||
          @vehicle_return.scheduled_location_was != @params[:scheduled_location]
      end
    end
  end
end
