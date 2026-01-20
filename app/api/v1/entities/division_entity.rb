module V1
  module Entities
    class DivisionEntity < Grape::Entity
      expose :id
      expose :code
      expose :name
      expose :description
      expose :active
    end
  end
end
