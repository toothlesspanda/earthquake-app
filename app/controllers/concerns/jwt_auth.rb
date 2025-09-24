require "jwt"

module JwtAuth
  extend ActiveSupport::Concern

  def verify_jwt_token
    token = token_from_header

    error_response("Authorization token is invalid", :unauthorized) unless valid_token?(token)
  end

  private

  def token_from_header
    token = request.headers["Authorization"]&.split(" ")

    unless token.present? || token[1].present?
      return error_response("Authorization token is missing", :unauthorized)
    end

    token[1]
  end

  def valid_token?(token)
    decoded_payload = JWT.decode(token, ENV["API_JWT_SECRET"], true, algorithm: "HS256")[0]
    request.env[:jwt_payload] = ActiveSupport::HashWithIndifferentAccess.new(decoded_payload)
    true
  rescue JWT::DecodeError => e
    Rails.logger.warn("JWT decode error: #{e.message}")
    false
  end
end
