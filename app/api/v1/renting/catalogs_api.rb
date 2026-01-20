# frozen_string_literal: true

module V1
  module Renting
    class CatalogsApi < Grape::API
      resource :renting do
        # GET /api/v1/renting/vehicle_types
        desc "List all vehicle types"
        get :vehicle_types do
          vehicle_types = ::Renting::VehicleType.active
          present vehicle_types, with: V1::Entities::Renting::VehicleTypeEntity
        end

        # GET /api/v1/renting/services
        desc "List all services"
        get :services do
          services = ::Renting::Service.active
          present services, with: V1::Entities::Renting::ServiceEntity
        end
      end
    end
  end
end
