module ApiErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    rescue_from ActionController::ParameterMissing, with: :render_bad_request
  end

  private

  def render_not_found(exception)
    render json: {
      errors: [
        {
          status: "404",
          title: "Resource Not Found",
          detail: exception.message
        }
      ]
    }, status: :not_found
  end

  def render_bad_request(exception)
    render json: {
      errors: [
        {
          status: "400",
          title: "Bad Request",
          detail: exception.message
        }
      ]
    }, status: :bad_request
  end
end
