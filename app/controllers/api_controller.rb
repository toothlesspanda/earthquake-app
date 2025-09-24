class ApiController < ActionController::Base
  include Pagy::Backend
  include Pagy::Frontend
  include ApiErrorHandling
  include JwtAuth
  include Devise::Controllers::Helpers

  before_action :verify_jwt_token
end
