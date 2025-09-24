require 'faker'
RGeoFactory = RGeo::Geographic.spherical_factory(srid: 4326)

FactoryBot.define do
  factory :earthquake do
    title { "M #{rand(1.0..8.0).round(1)} - Near Test Location" }
    event_id { "us#{Faker::Alphanumeric.alphanumeric(number: 8)}" }
    occurred_at { Faker::Time.between(from: 3.days.ago, to: Time.now) }
    coordinates do
      longitude = Faker::Address.longitude
      latitude = Faker::Address.latitude
      RGeoFactory.point(longitude, latitude)
    end
    magnitude { rand(1.0..8.0).round(1) }
    tsunami { [ true, false ].sample }
    depth_km { rand(1.0..500.0).round(1) }
    metadata { { "place" => Faker::Address.city } }
  end
end
