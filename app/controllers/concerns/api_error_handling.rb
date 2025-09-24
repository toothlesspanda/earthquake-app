module ApiErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActionController::ParameterMissing, with: :render_bad_request
  end

  def render_unauthenticated(exception)
    error_response(exception.message, :unauthorized)
  end

  def render_not_found(exception)
    error_response(exception.message, :bad_request)
  end

  def render_bad_request(exception)
    error_response(exception.message, :bad_request)
  end

  private

  def error_response(message, status_code)
    render json: {
      errors: [
        {
          status: Rack::Utils.status_code(status_code).to_s,
          title: Rack::Utils::HTTP_STATUS_CODES[Rack::Utils.status_code(status_code)],
          detail: message
        }
      ]
    }, status: status_code
  end
end
