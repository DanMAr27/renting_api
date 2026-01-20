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

          # POST /api/v1/renting/vehicles/:id/complete_delivery
          desc "Complete delivery (register vehicle data and activate)"
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
              vehicle = ::Renting::Vehicle.find(params[:id])
              completer = ::Renting::Delivery::Completer.new(vehicle, params.to_h)
              completer.call

              if completer.success?
                present vehicle.reload, with: V1::Entities::Renting::VehicleEntity
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
