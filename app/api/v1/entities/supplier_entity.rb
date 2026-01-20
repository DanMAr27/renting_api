module V1
  module Entities
    class SupplierEntity < Grape::Entity
      expose :id
      expose :name
      expose :tax_id
      expose :active
    end
  end
end
