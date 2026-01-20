module V1
  module Entities
    module Renting
      class OrderSeriesEntity < Grape::Entity
        expose :id
        expose :code
        expose :prefix
        expose :name do |series|
          "#{series.code} (#{series.prefix})"
        end
        expose :active
      end
    end
  end
end
