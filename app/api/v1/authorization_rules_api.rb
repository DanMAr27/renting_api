module V1
  class AuthorizationRulesApi < Grape::API
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

      def authorize_admin!
        error!("Prohibido: Se requieren permisos de administrador", 403) unless current_user&.admin?
      end
    end

    before do
      authenticate!
    end

    resource :authorization do
      desc "List authorization rules"
      params do
        optional :authorizable_type, type: String
        optional :active, type: Boolean
      end
      get :rules do
        rules = AuthorizationRule.all

        rules = rules.where(authorizable_type: params[:authorizable_type]) if params[:authorizable_type]
        rules = rules.where(active: params[:active]) if params.key?(:active)

        rules = rules.order(:authorizable_type, :approval_level)

        present rules, with: V1::Entities::AuthorizationRuleEntity
      end

      desc "Get authorization rule details"
      params do
        requires :id, type: Integer
      end
      get "rules/:id" do
        rule = AuthorizationRule.find(params[:id])
        present rule, with: V1::Entities::AuthorizationRuleEntity
      end

      desc "Create authorization rule"
      params do
        requires :authorizable_type, type: String
        requires :name, type: String
        requires :required_role, type: String
        requires :approval_level, type: Integer
        optional :condition_field, type: String
        optional :condition_operator, type: String, values: %w[greater_than less_than greater_or_equal less_or_equal equal not_equal]
        optional :condition_value, type: BigDecimal
        optional :active, type: Boolean, default: true
      end
      post :rules do
        authorize_admin!

        rule = AuthorizationRule.create!(
          authorizable_type: params[:authorizable_type],
          name: params[:name],
          condition_field: params[:condition_field],
          condition_operator: params[:condition_operator],
          condition_value: params[:condition_value],
          required_role: params[:required_role],
          approval_level: params[:approval_level],
          active: params[:active]
        )

        present rule, with: V1::Entities::AuthorizationRuleEntity
      end

      desc "Update authorization rule"
      params do
        requires :id, type: Integer
        optional :name, type: String
        optional :condition_field, type: String
        optional :condition_operator, type: String, values: %w[greater_than less_than greater_or_equal less_or_equal equal not_equal]
        optional :condition_value, type: BigDecimal
        optional :required_role, type: String
        optional :approval_level, type: Integer
        optional :active, type: Boolean
      end
      put "rules/:id" do
        authorize_admin!

        rule = AuthorizationRule.find(params[:id])
        rule.update!(declared(params, include_missing: false).except(:id))

        present rule, with: V1::Entities::AuthorizationRuleEntity
      end

      desc "Delete authorization rule"
      params do
        requires :id, type: Integer
      end
      delete "rules/:id" do
        authorize_admin!

        rule = AuthorizationRule.find(params[:id])
        rule.destroy!

        { success: true, message: "Regla de autorización eliminada exitosamente" }
      end
    end
  end
end
