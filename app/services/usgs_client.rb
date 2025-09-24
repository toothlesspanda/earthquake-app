# app/services/my_api_client.rb
require "net/http"
require "json"
require "uri"

class UsgsClient
  BASE_URL = "https://earthquake.usgs.gov/fdsnws/event/1/"

  Feature = Data.define(
  :title,
    :magnitude,
    :place,
    :time,
    :event_id,
    :coordinates,
    :depth_km,
    :tsunami,
  )
  def self.get_earthquakes(params = {})
    uri = URI("#{BASE_URL}/query")
    uri.query = URI.encode_www_form(params)

    res = Net::HTTP.get_response(uri)

    if res.is_a?(Net::HTTPSuccess)
      res = JSON.parse(res.body)
      features = res["features"].map do |feature|
        process_feature(feature)
      end
      features
    else
      { "error" => "Request failed parsing json" }
    end
  rescue StandardError => e
    Rails.logger.error("USGS#get_data: #{e.message}")
     { "error" => "Request failed #{e.message}" }
  end

  private

  def self.process_feature(feature)
    Feature.new(
      event_id: feature["id"],
      title: feature["properties"]["title"],
      magnitude: feature["properties"]["mag"],
      place: feature["properties"]["place"],
      time: feature["properties"]["time"],
      tsunami: feature["properties"]["tsunami"],
      coordinates: [ feature["geometry"]["coordinates"][0], feature["geometry"]["coordinates"][1] ],
      depth_km: feature["geometry"]["coordinates"][2]
    )
  end
end
