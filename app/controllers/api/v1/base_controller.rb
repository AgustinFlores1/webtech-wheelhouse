module Api
  module V1
    class BaseController < ActionController::API
      include ActionController::HttpAuthentication::Token::ControllerMethods

      rescue_from ActiveRecord::RecordNotFound do
        render_errors("There is no #{controller_name.singularize} with id #{params[:id]}", :not_found)
      end

      rescue_from ActionController::BadRequest, ActionController::ParameterMissing do |error|
        render_errors(error.message, :bad_request)
      end

      rescue_from ActionDispatch::Http::Parameters::ParseError do
        render_errors("The request body is not valid JSON", :bad_request)
      end

      def route_not_found
        render_errors("There is no route for #{request.method} #{request.path}", :not_found)
      end

      private

      def authenticate
        authenticated = authenticate_with_http_token do |token, _options|
          expected = Rails.application.credentials.api_token
          expected.present? && ActiveSupport::SecurityUtils.secure_compare(token, expected)
        end

        render_errors("Requieres a valid API token", :unauthorized) unless authenticated
      end

      def render_errors(messages, status)
        render json: { errors: Array(messages) }, status: status
      end
    end
  end
end