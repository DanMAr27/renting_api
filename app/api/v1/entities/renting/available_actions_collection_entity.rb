# frozen_string_literal: true

module V1
  module Entities
    module Renting
      class AvailableActionsCollectionEntity < Grape::Entity
        expose :transitions, documentation: { type: "Array[String]", desc: "Available AASM transitions" }
        expose :actions, using: ActionButtonEntity, documentation: { is_array: true, desc: "Available action buttons" }
        expose :related_entities, documentation: { type: "Hash", desc: "Related entity actions" }
      end
    end
  end
end
