module Api
  module V1
    class EarthquakesController < ApiController
      def index
        earthquakes = Earthquake.ransack(params).result(distinct: true)

        @pagy, @earthquakes = pagy(earthquakes, limit: params[:limit] || 100)

        render json: {
          data: @earthquakes,
          metadata: {
            page: @pagy.page,
            next: @pagy.next,
            prev: @pagy.prev,
            total: @pagy.count,
            limit: @pagy.limit
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
