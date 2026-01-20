# frozen_string_literal: true

module V1
  module Renting
    class OrdersApi < Grape::API
      resource :renting do
        resource :orders do
          # GET /api/v1/renting/orders
          desc "List all orders"
          params do
            optional :status, type: String, desc: "Filter by status"
            optional :company_id, type: Integer, desc: "Filter by company"
          end
          get do
            orders = ::Renting::Order.includes(:vehicle_spec, :contract_condition, :services, :company, :supplier, :created_by)
            orders = orders.by_status(params[:status]) if params[:status].present?
            orders = orders.where(company_id: params[:company_id]) if params[:company_id].present?
            orders = orders.recent.limit(50)

            present orders, with: V1::Entities::Renting::OrderEntity
          end

          # GET /api/v1/renting/orders/:id
          desc "Get order details"
          params do
            requires :id, type: Integer, desc: "Order ID"
          end
          route_param :id do
            get do
              order = ::Renting::Order.includes(:vehicle_spec, :contract_condition, :services).find(params[:id])
              present order, with: V1::Entities::Renting::OrderEntity
            end
          end

          # POST /api/v1/renting/orders
          desc "Create one or multiple orders"
          params do
            requires :company_id, type: Integer
            requires :supplier_id, type: Integer
            requires :order_series_id, type: Integer
            optional :expected_delivery_date, type: Date
            optional :is_renewal, type: Boolean, default: false
            optional :notes, type: String

            requires :vehicle_spec, type: Hash do
              requires :vehicle_type_id, type: Integer
              requires :fuel_type, type: String, values: [ "gasoline", "diesel", "electric", "hybrid", "plugin_hybrid" ]
              requires :transmission, type: String, values: [ "manual", "automatic" ]
              requires :min_seats, type: Integer
              optional :environmental_label, type: String
              optional :preferred_color, type: String
              optional :additional_equipment, type: String
            end

            requires :contract_condition, type: Hash do
              requires :duration_months, type: Integer
              requires :annual_km, type: Integer
              requires :monthly_fee, type: Float
              optional :initial_payment, type: Float
              optional :deposit, type: Float
              optional :contract_start_date, type: Date
            end

            requires :assignments, type: Array do
              requires :usage_type, type: String, values: [ "individual", "collective" ]
              optional :driver_id, type: Integer
              optional :cost_center_id, type: Integer
              optional :department_id, type: Integer
              optional :division_id, type: Integer
              optional :is_renewal, type: Boolean, default: false
              optional :old_vehicle_id, type: Integer
            end

            optional :service_ids, type: Array[Integer]
          end
          post do
            bulk_creator = ::Renting::Orders::BulkCreator.new(params.to_h, current_user)
            orders = bulk_creator.call

            if bulk_creator.success?
              present orders, with: V1::Entities::Renting::OrderEntity
            else
              error!({ errors: bulk_creator.errors }, 422)
            end
          end

          # POST /api/v1/renting/orders/:id/submit
          desc "Submit order for authorization"
          params do
            requires :id, type: Integer
          end
          route_param :id do
            post :submit do
              order = ::Renting::Order.find(params[:id])

              policy = ::Renting::Authorization::Policy.new(order)
              if policy.requires_authorization?
                ::Renting::Authorization::RequestCreator.new(order).call
                { message: "Order submitted for authorization", status: order.reload.status }
              else
                # Auto-approve if no authorization required
                state_machine = ::Renting::Orders::StateMachine.new(order, current_user)
                state_machine.transition_to!("authorized", notes: "Auto-approved (no authorization required)")
                { message: "Order auto-approved", status: order.reload.status }
              end
            end
          end

          # POST /api/v1/renting/orders/:id/approve
          desc "Approve order"
          params do
            requires :id, type: Integer
          end
          route_param :id do
            post :approve do
              order = ::Renting::Order.find(params[:id])
              handler = ::Renting::Authorization::ResponseHandler.new(order)
              handler.handle_approval

              { message: "Order approved", status: order.reload.status }
            end
          end

          # POST /api/v1/renting/orders/:id/reject
          desc "Reject order"
          params do
            requires :id, type: Integer
            optional :reason, type: String
          end
          route_param :id do
            post :reject do
              order = ::Renting::Order.find(params[:id])
              handler = ::Renting::Authorization::ResponseHandler.new(order)
              handler.handle_rejection(params[:reason])

              { message: "Order rejected", status: order.reload.status }
            end
          end

          # POST /api/v1/renting/orders/:id/complete_delivery
          desc "Complete delivery and create vehicle/contract"
          params do
            requires :id, type: Integer
            requires :license_plate, type: String
            requires :vin, type: String
            requires :color, type: String
            requires :initial_km, type: Integer
            optional :supplier_contract_number, type: String
            optional :delivery_date, type: Date
            optional :contract_start_date, type: Date
          end
          route_param :id do
            post :complete_delivery do
              order = ::Renting::Order.find(params[:id])
              completer = ::Renting::Delivery::Completer.new(order, params.to_h)
              completer.call

              if completer.success?
                present order.reload, with: V1::Entities::Renting::OrderEntity
              else
                error!({ errors: completer.errors }, 422)
              end
            end
          end
        end
      end
    end
  end
end
