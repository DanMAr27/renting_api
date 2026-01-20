# frozen_string_literal: true

module V1
  module Renting
    class Base < Grape::API
      # No redefinir version, format, prefix aquí
      # Heredan de V1::Base

      helpers do
        def current_user
          # For PoC: return first user
          # In production: implement authentication
          @current_user ||= User.first
        end

        def authenticate!
          error!("Unauthorized", 401) unless current_user
        end
      end

      before do
        authenticate!
      end

      mount V1::Renting::CatalogsApi
      mount V1::Renting::OrdersApi
      mount V1::Renting::VehiclesApi
      mount V1::Renting::ContractsApi
      mount V1::Renting::ReturnsApi
    end
  end
end
