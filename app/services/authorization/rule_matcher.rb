# frozen_string_literal: true

module Authorization
  class RuleMatcher
    def initialize(authorizable)
      @authorizable = authorizable
    end

    def matching_rules
      AuthorizationRule.active
                       .for_type(@authorizable.class.name)
                       .by_level
                       .select { |rule| rule.matches?(@authorizable) }
    end

    def max_approval_level
      matching_rules.maximum(:approval_level) || 0
    end

    def requires_authorization?
      max_approval_level > 0
    end
  end
end
