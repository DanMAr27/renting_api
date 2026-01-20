# frozen_string_literal: true

module V1
  module Renting
    class ReturnsApi < Grape::API
      resource :renting do
        resource :vehicles do
          route_param :id do
            resource :return do
              # GET /api/v1/renting/vehicles/:id/return
              desc "Get return status"
              get do
                vehicle = ::Renting::Vehicle.find(params[:id])
                vehicle_return = vehicle.vehicle_return

                if vehicle_return
                  present vehicle_return, with: V1::Entities::Renting::VehicleReturnEntity
                else
                  error!({ error: "Return process not initiated for this vehicle" }, 404)
                end
              end

              # POST /api/v1/renting/vehicles/:id/return/schedule
              desc "Schedule vehicle return"
              params do
                requires :scheduled_date, type: Date
                optional :scheduled_time, type: Time
                requires :scheduled_location, type: String
                optional :scheduling_notes, type: String
              end
              post :schedule do
                vehicle = ::Renting::Vehicle.find(params[:id])
                vehicle_return = vehicle.vehicle_return

                if vehicle_return.nil?
                   error!({ error: "Return process not initiated. Start contract termination first." }, 422)
                end

                scheduler = ::Renting::Returns::Scheduler.new(vehicle_return, params, current_user)
                scheduler.call

                if scheduler.success?
                  present vehicle_return, with: V1::Entities::Renting::VehicleReturnEntity
                else
                  error!({ errors: scheduler.errors }, 422)
                end
              end

              # POST /api/v1/renting/vehicles/:id/return/confirm
              desc "Confirm vehicle return (physical handover)"
              params do
                requires :actual_return_date, type: Date
                requires :final_km, type: Integer
                optional :return_notes, type: String
              end
              post :confirm do
                vehicle = ::Renting::Vehicle.find(params[:id])
                vehicle_return = vehicle.vehicle_return

                if vehicle_return.nil?
                   error!({ error: "Return process not initiated." }, 422)
                end

                confirmer = ::Renting::Returns::Confirmer.new(vehicle_return, params, current_user)
                confirmer.call

                if confirmer.success?
                  present vehicle_return, with: V1::Entities::Renting::VehicleReturnEntity
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
