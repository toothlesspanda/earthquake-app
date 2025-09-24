module Api
  module V1
    class EarthquakesController < ApiController
      # You may want to skip authenticity token checks for an API
      skip_before_action :verify_authenticity_token

      def index
        earthquakes = Earthquake.ransack(params).result(distinct: true)

        @pagy, @earthquakes = pagy(earthquakes)

        render json: {
          data: @earthquakes,
          metadata: {
            pagy: pagy_data(@pagy)
          }
        }
      end

      def show
        @earthquake = Earthquake.find(params[:id])
        render json: @earthquake
      end
    end
  end
end
