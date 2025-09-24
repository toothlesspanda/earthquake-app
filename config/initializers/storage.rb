Rails.configuration.to_prepare do
  StoreRecentEarthquakes.new.call if Earthquake.all.empty?
end
