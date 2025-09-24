class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Pagy::Frontend

  before_action :authenticate_user!

  layout -> { current_user ?  "application" : "login" }
end
