class ApiController < ActionController::Base
  include Pagy::Backend
  include Pagy::Frontend
  include ApiErrorHandling

  before_action :authenticate_user!
end
