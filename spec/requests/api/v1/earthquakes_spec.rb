require 'swagger_helper'

RSpec.describe 'Earthquakes API', type: :request do
  let(:valid_auth_header) { { 'Authorization' => 'Bearer VALID_TEST_TOKEN' } }
  let(:host_header) { { 'Host' => 'api.example.com' } }

  path '/api/v1/earthquakes' do
    get 'Retrieves a list of earthquakes with filtering and pagination' do
      tags 'Earthquakes'
      produces 'application/json'
      security [ { bearer_auth: [] } ]

      parameter '$ref': :PagyParams
      parameter '$ref': :PagyItems
      parameter '$ref': :RansackMagnitudeGteq
      parameter '$ref': :RansackMagnitudeLteq
      parameter '$ref': :RansackOccurredAtGteq
      parameter '$ref': :RansackOccurredAtLteq
      parameter '$ref': :RansackTsunamiEq

      # SUCCESS RESPONSE
      response '200', 'earthquakes retrieved successfully' do
        schema type: :object,
               properties: {
                 data: { type: :array, description: 'List of earthquake records.' },
                 metadata: {
                   type: :object,
                   properties: {
                     pagy: { type: :object, description: 'Pagination metadata (page, items, count, pages, etc.).' }
                   },
                   required: [ 'pagy' ]
                 }
               }

        it 'returns a 200 status code' do
          get '/api/v1/earthquakes', headers: { 'Host' => 'api.example.com' }
          expect(response).to have_http_status(:ok)

          json_response = JSON.parse(response.body)
          expect(json_response['data']).to be_an(Array)
          expect(json_response['metadata']).to include('pagy')
        end

        it 'filters by magnitude_gteq (Bigger Magnitude)' do
          get '/api/v1/earthquakes', params: { magnitude_gteq: 5.0 }, headers: valid_auth_header.merge(host_header)
          expect(response).to have_http_status(:ok)
        end
      end

      response '422', 'invalid query parameters' do
        let(:magnitude_gteq) { 'invalid_text' } # Example invalid value

        it 'returns a 422 status code (if custom error handling is implemented)' do
          get '/api/v1/earthquakes', params: { magnitude_gteq: 'invalid_text' }, headers: valid_auth_header.merge(host_header)
        end
      end
    end
  end

  path '/api/v1/earthquakes/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'ID of the earthquake record'

    get 'Retrieves a specific earthquake record' do
      tags 'Earthquakes'
      produces 'application/json'
      security [ { bearer_auth: [] } ]

      let(:earthquake_record) { create(:earthquake, title: 'M 5.5 - Test Event', event_id: 'tst01', occurred_at: Time.now.utc, magnitude: 5.5, tsunami: false, depth_km: 10.0) }
      let(:id) { earthquake_record.id }

      response '200', 'earthquake found' do
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 title: { type: :string, example: 'M 5.5 - Test Event' },
                 magnitude: { type: :number, format: :float, example: 5.5 }
               },
               required: [ 'id', 'title', 'magnitude' ]

        it 'returns a 200 status code and the correct record' do
          get "/api/v1/earthquakes/#{id}", headers: valid_auth_header.merge(host_header)
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response['title']).to eq('M 5.5 - Test Event')
        end
      end

      response '404', 'earthquake not found' do
        let(:id) { '0' }

        it 'returns a 404 status code' do
          get "/api/v1/earthquakes/#{id}", headers: { 'Host' => 'api.example.com' }
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
