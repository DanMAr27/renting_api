module V1
  module Entities
    class CostCenterEntity < Grape::Entity
      expose :id
      expose :code
      expose :name
      expose :description
      expose :active
    end
  end
end
