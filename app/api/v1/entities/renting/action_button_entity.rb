# frozen_string_literal: true

module V1
  module Entities
    module Renting
      class ActionButtonEntity < Grape::Entity
        expose :name, documentation: { type: "String", desc: "Action name" }
        expose :label, documentation: { type: "String", desc: "Human-readable label" }
        expose :endpoint, documentation: { type: "String", desc: "API endpoint" }
        expose :primary, documentation: { type: "Boolean", desc: "Is primary action" }
        expose :destructive, documentation: { type: "Boolean", desc: "Is destructive action" }
      end
    end
  end
end
