# frozen_string_literal: true

module V1
  module Entities
    module Renting
      class VehicleTypeEntity < Grape::Entity
        expose :id
        expose :code
        expose :name
        expose :description
        expose :active
      end
    end
  end
end
