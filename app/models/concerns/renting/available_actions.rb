# frozen_string_literal: true

module Renting
  module AvailableActions
    extend ActiveSupport::Concern

    def available_actions
      {
        transitions: available_transitions,
        actions: available_action_buttons,
        related_entities: related_entity_actions
      }
    end

    private

    def available_transitions
      # Usar AASM para obtener eventos disponibles
      aasm.events(permitted: true).map(&:name)
    end

    def available_action_buttons
      # Implementar en cada modelo
      []
    end

    def related_entity_actions
      # Implementar en cada modelo
      {}
    end
  end
end
