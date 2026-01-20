# frozen_string_literal: true

module Renting
  module Orders
    class BulkCreator
      attr_reader :errors, :orders

      def initialize(params, current_user)
        @params = params.with_indifferent_access
        @current_user = current_user
        @errors = []
        @orders = []
      end

      def call
        validate_assignments
        return [] if @errors.any?

        ActiveRecord::Base.transaction do
          @params[:assignments].each_with_index do |assignment, index|
            order_params = build_order_params(assignment, index)
            creator = Creator.new(order_params, @current_user)
            order = creator.call

            if creator.success?
              @orders << order
            else
              @errors << "Order #{index + 1}: #{creator.errors.join(', ')}"
              raise ActiveRecord::Rollback
            end
          end

          @orders
        rescue ActiveRecord::RecordInvalid => e
          @errors << e.message
          raise ActiveRecord::Rollback
        end
      end

      def success?
        @errors.empty? && @orders.any?
      end

      private

      def validate_assignments
        if @params[:assignments].blank? || !@params[:assignments].is_a?(Array)
          @errors << "assignments must be a non-empty array"
        elsif @params[:assignments].empty?
          @errors << "assignments cannot be empty"
        end
      end

      def build_order_params(assignment, index)
        {
          company_id: @params[:company_id],
          supplier_id: @params[:supplier_id],
          order_series_id: @params[:order_series_id],
          expected_delivery_date: @params[:expected_delivery_date],
          is_renewal: assignment[:is_renewal] || @params[:is_renewal] || false,
          old_vehicle_id: assignment[:old_vehicle_id],
          notes: build_notes(assignment, index),
          vehicle_spec: @params[:vehicle_spec],
          contract_condition: @params[:contract_condition],
          assignment: assignment,
          service_ids: @params[:service_ids]
        }
      end

      def build_notes(assignment, index)
        notes = []
        notes << @params[:notes] if @params[:notes].present?
        notes << "Vehículo #{index + 1} de #{@params[:assignments].size}"
        notes.join(" | ")
      end
    end
  end
end
