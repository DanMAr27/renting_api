module V1
  module Entities
    class DepartmentEntity < Grape::Entity
      expose :id
      expose :code
      expose :name
      expose :description
      expose :active
    end
  end
end
