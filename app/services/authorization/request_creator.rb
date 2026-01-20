# frozen_string_literal: true

module Authorization
  class RequestCreator
    attr_reader :authorization_request

    def initialize(authorizable, requested_by)
      @authorizable = authorizable
      @requested_by = requested_by
    end

    def call
      matcher = Authorization::RuleMatcher.new(@authorizable)

      return nil unless matcher.requires_authorization?

      @authorization_request = AuthorizationRequest.create!(
        authorizable: @authorizable,
        requested_by: @requested_by,
        amount: extract_amount,
        status: "pending",
        current_level: 1,
        max_level: matcher.max_approval_level
      )
    end

    private

    def extract_amount
      # Extrae el monto según el tipo de recurso
      case @authorizable
      when Renting::Order
        @authorizable.contract_condition&.monthly_fee || 0
      else
        0
      end
    end
  end
end
