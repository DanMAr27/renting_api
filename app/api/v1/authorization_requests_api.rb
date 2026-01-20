module V1
  class AuthorizationRequestsApi < Grape::API
    format :json

    helpers do
      def current_user
        # PoC: Obtener usuario del header o usar el primero por defecto
        user_id = headers["X-User-Id"] if respond_to?(:headers) && headers
        @current_user ||= (User.find_by(id: user_id) || User.first)
      end

      def authenticate!
        error!("No autorizado", 401) unless current_user
      end
    end

    before do
      authenticate!
    end

    resource :authorization do
      desc "List authorization requests"
      params do
        optional :status, type: String, values: %w[pending approved rejected cancelled]
        optional :authorizable_type, type: String
        optional :page, type: Integer, default: 1
        optional :per_page, type: Integer, default: 20
      end
      get :requests do
        requests = AuthorizationRequest.includes(:requested_by, :approvals)

        requests = requests.where(status: params[:status]) if params[:status]
        requests = requests.where(authorizable_type: params[:authorizable_type]) if params[:authorizable_type]

        requests = requests.page(params[:page]).per(params[:per_page])

        present requests, with: V1::Entities::AuthorizationRequestEntity, current_user: current_user
      end

      desc "Get pending authorization requests for current user"
      get "requests/pending" do
        # Encuentra solicitudes pendientes que el usuario puede aprobar
        pending_requests = AuthorizationRequest.pending
                                               .includes(:requested_by, :approvals)
                                               .select { |req| req.can_approve?(current_user) }

        present pending_requests, with: V1::Entities::AuthorizationRequestEntity, current_user: current_user
      end

      desc "Get authorization request details"
      params do
        requires :id, type: Integer
      end
      get "requests/:id" do
        request = AuthorizationRequest.includes(:requested_by, :approvals, :authorizable).find(params[:id])
        present request, with: V1::Entities::AuthorizationRequestEntity, current_user: current_user
      end

      desc "Approve authorization request"
      params do
        requires :id, type: Integer
        optional :notes, type: String
      end
      post "requests/:id/approve" do
        auth_request = AuthorizationRequest.find(params[:id])

        error!("No tienes permiso para aprobar esta solicitud", 403) unless auth_request.can_approve?(current_user)
        error!("La solicitud no está pendiente", 400) unless auth_request.pending?

        processor = Authorization::ApprovalProcessor.new(
          auth_request,
          current_user,
          "approved",
          params[:notes]
        )

        processor.call

        present auth_request.reload, with: V1::Entities::AuthorizationRequestEntity, current_user: current_user
      end

      desc "Reject authorization request"
      params do
        requires :id, type: Integer
        optional :notes, type: String
      end
      post "requests/:id/reject" do
        auth_request = AuthorizationRequest.find(params[:id])

        error!("No tienes permiso para rechazar esta solicitud", 403) unless auth_request.can_approve?(current_user)
        error!("La solicitud no está pendiente", 400) unless auth_request.pending?

        processor = Authorization::ApprovalProcessor.new(
          auth_request,
          current_user,
          "rejected",
          params[:notes]
        )

        processor.call

        present auth_request.reload, with: V1::Entities::AuthorizationRequestEntity, current_user: current_user
      end
    end
  end
end
