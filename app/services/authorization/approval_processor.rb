# frozen_string_literal: true

module Authorization
  class ApprovalProcessor
    attr_reader :errors

    def initialize(authorization_request, approver, action, notes = nil)
      @request = authorization_request
      @approver = approver
      @action = action
      @notes = notes
      @errors = []
    end

    def call
      return false unless validate_approval

      ActiveRecord::Base.transaction do
        create_approval
        update_request_status
        notify_authorizable
      end

      true
    rescue ActiveRecord::RecordInvalid => e
      @errors << e.message
      false
    end

    private

    def validate_approval
      unless @request.can_approve?(@approver)
        @errors << "User #{@approver.email} cannot approve this request at level #{@request.current_level}"
        return false
      end

      true
    end

    def create_approval
      AuthorizationApproval.create!(
        authorization_request: @request,
        approver: @approver,
        approval_level: @request.current_level,
        action: @action,
        notes: @notes
      )
    end

    def update_request_status
      if @action == "rejected"
        @request.complete_rejection!
      elsif @request.fully_approved?
        @request.complete_approval!
      else
        @request.next_level!
      end
    end

    def notify_authorizable
      # Notifica al recurso autorizable del cambio
      case @request.authorizable
      when Renting::Order
        handle_renting_order_authorization
      end
    end

    def handle_renting_order_authorization
      handler = Renting::Authorization::ResponseHandler.new(@request.authorizable)

      if @request.approved?
        handler.handle_approval
      elsif @request.rejected?
        handler.handle_rejection(@notes)
      end
    end
  end
end
