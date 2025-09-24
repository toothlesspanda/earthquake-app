class HomeController < ApplicationController
  before_action :set_data, only: [ :index ]
  def index
  end


  private

  def set_data
    @earthquakes = Earthquake.all.to_a
  end
end
