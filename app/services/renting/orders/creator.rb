# frozen_string_literal: true

module Renting
  module Orders
    class Creator
      attr_reader :errors

      def initialize(params, current_user)
        @params = params
        @current_user = current_user
        @errors = []
      end

      def call
        ActiveRecord::Base.transaction do
          create_order
          create_vehicle_spec
          create_contract_condition
          create_assignment
          create_services
          record_initial_status

          @order
        rescue ActiveRecord::RecordInvalid => e
          @errors << e.message
          raise ActiveRecord::Rollback
        end
      end

      def success?
        @errors.empty? && @order.present?
      end

      private

      def create_order
        order_number = Renting::Orders::NumberGenerator.new(order_series).generate

        @order = Renting::Order.create!(
          order_number: order_number,
          company_id: @params[:company_id],
          supplier_id: @params[:supplier_id],
          order_series: order_series,
          created_by: @current_user,
          status: "created",
          order_date: @params[:order_date] || Date.current,
          expected_delivery_date: @params[:expected_delivery_date],
          is_renewal: @params[:is_renewal] || false,
          old_vehicle_id: @params[:old_vehicle_id],
          notes: @params[:notes]
        )
      end

      def create_vehicle_spec
        return unless @params[:vehicle_spec].present?

        Renting::OrderVehicleSpec.create!(
          order: @order,
          vehicle_type_id: @params[:vehicle_spec][:vehicle_type_id],
          fuel_type: @params[:vehicle_spec][:fuel_type],
          environmental_label: @params[:vehicle_spec][:environmental_label],
          min_seats: @params[:vehicle_spec][:min_seats],
          transmission: @params[:vehicle_spec][:transmission],
          preferred_color: @params[:vehicle_spec][:preferred_color],
          additional_equipment: @params[:vehicle_spec][:additional_equipment]
        )
      end

      def create_contract_condition
        return unless @params[:contract_condition].present?

        Renting::OrderContractCondition.create!(
          order: @order,
          duration_months: @params[:contract_condition][:duration_months],
          annual_km: @params[:contract_condition][:annual_km],
          monthly_fee: @params[:contract_condition][:monthly_fee],
          initial_payment: @params[:contract_condition][:initial_payment],
          deposit: @params[:contract_condition][:deposit],
          contract_start_date: @params[:contract_condition][:contract_start_date]
        )
      end

      def create_assignment
        return unless @params[:assignment].present?

        Renting::OrderAssignment.create!(
          order: @order,
          usage_type: @params[:assignment][:usage_type],
          driver_id: @params[:assignment][:driver_id],
          cost_center_id: @params[:assignment][:cost_center_id],
          department_id: @params[:assignment][:department_id],
          division_id: @params[:assignment][:division_id]
        )
      end

      def create_services
        return unless @params[:service_ids].present?

        @params[:service_ids].each do |service_id|
          Renting::OrderService.create!(
            order: @order,
            service_id: service_id,
            monthly_price: @params[:service_prices]&.dig(service_id.to_s)
          )
        end
      end

      def record_initial_status
        Renting::OrderStatusHistory.create!(
          order: @order,
          from_status: "created",
          to_status: "created",
          changed_by: @current_user,
          changed_at: Time.current,
          notes: "Order created"
        )
      end

      def order_series
        @order_series ||= Renting::OrderSeries.find(@params[:order_series_id])
      end
    end
  end
end
