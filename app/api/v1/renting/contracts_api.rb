# frozen_string_literal: true

module V1
  module Renting
    class ContractsApi < Grape::API
      resource :renting do
        resource :contracts do
          # GET /api/v1/renting/contracts
          desc "List all contracts"
          params do
            optional :status, type: String, desc: "Filter by status"
          end
          get do
            contracts = ::Renting::Contract.includes(:vehicle, :supplier, :company, :order)
            contracts = contracts.where(status: params[:status]) if params[:status].present?
            contracts = contracts.recent.limit(50)

            present contracts, with: V1::Entities::Renting::ContractEntity
          end

          # GET /api/v1/renting/contracts/:id
          desc "Get contract details"
          params do
            requires :id, type: Integer, desc: "Contract ID"
          end
          route_param :id do
            get do
              contract = ::Renting::Contract.includes(:vehicle, :supplier, :company, :order).find(params[:id])
              present contract, with: V1::Entities::Renting::ContractEntity
            end
          end

          # GET /api/v1/renting/contracts/expiring
          desc "Get contracts expiring soon"
          params do
            optional :days, type: Integer, default: 30, desc: "Days until expiration"
          end
          get :expiring do
            contracts = ::Renting::Contract.includes(:vehicle, :supplier, :company, :order)
                                           .expiring_soon(params[:days])

            present contracts, with: V1::Entities::Renting::ContractEntity
          end
        end
      end
    end
  end
end
