# frozen_string_literal: true

module V1
  module Entities
    module Renting
      class VehicleReturnEntity < Grape::Entity
        expose :id
        expose :status
        expose :vehicle_id
        expose :contract_id

        expose :scheduled_date
        expose :scheduled_time
        expose :scheduled_location
        expose :scheduling_notes
        expose :reschedule_count
        expose :scheduled_at
        expose :scheduled_by_id

        expose :actual_return_date
        expose :final_km
        expose :return_notes
        expose :confirmed_at
        expose :confirmed_by_id

        expose :created_at
        expose :updated_at
      end
    end
  end
end
