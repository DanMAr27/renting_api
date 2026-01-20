# frozen_string_literal: true

module V1
  module Renting
    class VehiclesApi < Grape::API
      resource :renting do
        resource :vehicles do
          # GET /api/v1/renting/vehicles
          desc "List all vehicles"
          params do
            optional :status, type: String, desc: "Filter by status"
          end
          get do
            vehicles = ::Renting::Vehicle.includes(:vehicle_type, :order)
            vehicles = vehicles.where(status: params[:status]) if params[:status].present?
            vehicles = vehicles.order(created_at: :desc).limit(50)

            present vehicles, with: V1::Entities::Renting::VehicleEntity
          end

          # GET /api/v1/renting/vehicles/:id
          desc "Get vehicle details"
          params do
            requires :id, type: Integer, desc: "Vehicle ID"
          end
          route_param :id do
            get do
              vehicle = ::Renting::Vehicle.includes(:vehicle_type, :order, :contract).find(params[:id])
              present vehicle, with: V1::Entities::Renting::VehicleEntity
            end
          end

          # Delivery Management
          route_param :id do
            resource :delivery do
              # GET /api/v1/renting/vehicles/:id/delivery
              desc "Get delivery status"
              get do
                vehicle = ::Renting::Vehicle.find(params[:id])
                delivery = vehicle.delivery

                if delivery
                  present delivery, with: V1::Entities::Renting::VehicleDeliveryEntity
                else
                  error!({ error: "Delivery not found for this vehicle" }, 404)
                end
              end

              # POST /api/v1/renting/vehicles/:id/delivery/schedule
              desc "Schedule vehicle delivery"
              params do
                requires :scheduled_date, type: Date
                optional :scheduled_time, type: Time
                requires :scheduled_location, type: String
                optional :scheduling_notes, type: String
              end
              post :schedule do
                vehicle = ::Renting::Vehicle.find(params[:id])
                delivery = vehicle.delivery

                scheduler = ::Renting::Delivery::Scheduler.new(delivery, params, current_user)
                scheduler.call

                if scheduler.success?
                  present delivery, with: V1::Entities::Renting::VehicleDeliveryEntity
                else
                  error!({ errors: scheduler.errors }, 422)
                end
              end

              # POST /api/v1/renting/vehicles/:id/delivery/confirm
              desc "Confirm delivery and activate vehicle/contract"
              params do
                requires :license_plate, type: String
                requires :vin, type: String
                requires :initial_km, type: Integer
                requires :supplier_contract_number, type: String
                optional :color, type: String
                optional :actual_delivery_date, type: Date
                optional :contract_start_date, type: Date
                optional :confirmation_notes, type: String
              end
              post :confirm do
                vehicle = ::Renting::Vehicle.find(params[:id])
                delivery = vehicle.delivery

                confirmer = ::Renting::Delivery::Confirmer.new(delivery, params, current_user)
                confirmer.call

                if confirmer.success?
                  present delivery, with: V1::Entities::Renting::VehicleDeliveryEntity
                else
                  error!({ errors: confirmer.errors }, 422)
                end
              end
            end
          end
        end
      end
    end
  end
end
