

class StoreRecentEarthquakes < ApplicationService
  attr_reader :start_date

  def initialize(start_date: nil)
    @start_date = start_date
  end
  def call
    data = UsgsClient.get_earthquakes(
      format: "geojson",
      starttime: start_date || 30.days.ago.strftime("%Y-%m-%d"),
    )

    data.each do |earthquake|
      factory = RGeo::Geographic.spherical_factory(srid: 4326)
      point = factory.point(earthquake.coordinates[0], earthquake.coordinates[1])
      Earthquake.find_or_create_by(event_id: earthquake.event_id) do |e|
        e.title = earthquake.title
        e.occurred_at = Time.at(earthquake.time/1000).utc
        e.coordinates = point
        e.magnitude = earthquake.magnitude
        e.metadata = { "place" => earthquake.place }
        e.tsunami = earthquake.tsunami.positive?
        e.depth_km = earthquake.depth_km
      end
    end

  rescue StandardError => e
    Rails.logger.error("StoreRecentEarthquakes#call: #{e.message}")
    nil
  end
end
