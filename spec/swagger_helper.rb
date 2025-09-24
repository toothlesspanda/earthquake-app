require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are located
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define the global API documentation structure
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Earthquake API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'api.example.com:3000'
            }
          }
        }
      ],
      # THIS IS THE KEY TO SHARING PARAMETERS: Define them once here.
      components: {
        parameters: {
          PagyParams: {
            name: :page,
            in: :query,
            schema: { type: :integer },
            required: false,
            description: 'Page number for pagination'
          },
          PagyItems: {
            name: :limit,
            in: :query,
            schema: { type: :integer },
            required: false,
            description: 'Number of items per page'
          },
          RansackMagnitudeGteq: {
            name: 'magnitude_gteq',
            in: :query,
            schema: { type: :number, format: :float },
            required: false,
            description: 'Filter for earthquakes with magnitude greater than or equal to this value (Bigger Magnitude).'
          },
          RansackMagnitudeLteq: {
            name: 'magnitude_lteq',
            in: :query,
            schema: { type: :number, format: :float },
            required: false,
            description: 'Filter for earthquakes with magnitude less than or equal to this value (Smaller Magnitude).'
          },
          RansackOccurredAtGteq: {
            name: 'occurred_at_gteq',
            in: :query,
            schema: { type: :string, format: 'date-time' },
            required: false,
            description: 'Filter for earthquakes that occurred after this date/time.'
          },
          RansackOccurredAtLteq: {
            name: 'occurred_at_lteq',
            in: :query,
            schema: { type: :string, format: 'date-time' },
            required: false,
            description: 'Filter for earthquakes that occurred before this date/time.'
          },
          RansackTsunamiEq: {
            name: 'tsunami_eq',
            in: :query,
            schema: { type: :boolean },
            required: false,
            description: 'Filter for tsunami events (true/false).'
          }
        }
      }
    }
  }
end
