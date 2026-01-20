# frozen_string_literal: true

module V1
  module Renting
    class CatalogsApi < Grape::API
      resource :renting do
        # GET /api/v1/renting/companies
        desc "List active companies", tags: [ "Catalogs" ]
        get :companies do
          companies = ::Company.active
          present companies, with: V1::Entities::CompanyEntity
        end

        # GET /api/v1/renting/suppliers
        desc "List active suppliers", tags: [ "Catalogs" ]
        get :suppliers do
          suppliers = ::Supplier.active
          present suppliers, with: V1::Entities::SupplierEntity
        end

        # GET /api/v1/renting/cost_centers
        desc "List active cost centers", tags: [ "Catalogs" ]
        get :cost_centers do
          cost_centers = ::CostCenter.active
          present cost_centers, with: V1::Entities::CostCenterEntity
        end

        # GET /api/v1/renting/departments
        desc "List active departments", tags: [ "Catalogs" ]
        get :departments do
          departments = ::Department.active
          present departments, with: V1::Entities::DepartmentEntity
        end

        # GET /api/v1/renting/divisions
        desc "List active divisions", tags: [ "Catalogs" ]
        get :divisions do
          divisions = ::Division.active
          present divisions, with: V1::Entities::DivisionEntity
        end

        # GET /api/v1/renting/users
        desc "List active users (drivers)", tags: [ "Catalogs" ]
        get :users do
          users = ::User.active
          present users, with: V1::Entities::UserEntity
        end

        # GET /api/v1/renting/order_series
        desc "List active order series", tags: [ "Catalogs" ]
        get :order_series do
          series = ::Renting::OrderSeries.active
          present series, with: V1::Entities::Renting::OrderSeriesEntity
        end

        # GET /api/v1/renting/vehicle_types
        desc "List all vehicle types", tags: [ "Catalogs" ]
        get :vehicle_types do
          vehicle_types = ::Renting::VehicleType.active
          present vehicle_types, with: V1::Entities::Renting::VehicleTypeEntity
        end

        # GET /api/v1/renting/services
        desc "List all services", tags: [ "Catalogs" ]
        get :services do
          services = ::Renting::Service.active
          present services, with: V1::Entities::Renting::ServiceEntity
        end
      end
    end
  end
end
