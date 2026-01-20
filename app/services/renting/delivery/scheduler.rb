# frozen_string_literal: true

module Renting
  module Delivery
    class Scheduler
      attr_reader :errors, :delivery

      def initialize(vehicle_delivery, scheduling_params, current_user)
        @delivery = vehicle_delivery
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
        # Si ya estaba programada y cambian datos, incrementamos contador
        if @delivery.scheduled? && scheduling_changed?
          @delivery.reschedule_count += 1
        end

        @delivery.update!(
          scheduled_date: @params[:scheduled_date],
          scheduled_time: @params[:scheduled_time],
          scheduled_location: @params[:scheduled_location],
          scheduling_notes: @params[:scheduling_notes],
          scheduled_by: @current_user,
          scheduled_at: Time.current
        )
      end

      def transition_to_scheduled
        if @delivery.pending_scheduling?
          @delivery.schedule!
        elsif @delivery.scheduled?
          @delivery.reschedule!
        else
          raise AASM::InvalidTransition.new(@delivery, :schedule, @delivery.status)
        end
      end

      def scheduling_changed?
        @delivery.scheduled_date_was != @params[:scheduled_date] ||
          @delivery.scheduled_time_was&.strftime("%H:%M") != @params[:scheduled_time]&.strftime("%H:%M") ||
          @delivery.scheduled_location_was != @params[:scheduled_location]
      end
    end
  end
end
