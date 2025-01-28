require 'rails_helper'

RSpec.describe '/search', type: :request do
  describe 'GET /search' do
    let(:city) { 'Sigulda' }
    let(:query) { 'Pils' }

    # Mocks for DB
    before do
      city_record = City.create!(name: city, coat_of_arms_url: 'http://example.com/sigulda.png')

      Hotel.create!([
                      { display_name: 'Hotel Pils', city: city_record },
                      { display_name: 'Kaķis', city: city_record },
                      { display_name: 'Sigulda', city: city_record },
                      { display_name: 'Kaķu māja', city: city_record }
                    ])
    end

    it 'returns result under 100ms' do
      start_time = Time.now
      get('/api/search.json', params: { city: city, q: query })
      end_time = Time.now

      request_time = end_time - start_time

      expect(request_time.to_f).to be < 0.1 # under 100ms
    end

    let(:expected_result) do
      [
        { 'id' => anything, 'display_name' => 'Hotel Pils',
          'city' => { 'name' => city, 'coat_of_arms_url' => 'http://example.com/sigulda.png' } }
      ]
    end

    it 'returns all hotels with Pils from Sigulda' do
      get('/api/search.json', params: { city: city, q: query })

      parsed_response = JSON.parse(response.body)

      expect(parsed_response).to match_array(expected_result)
    end

    it 'returns hotels for a city without a query' do
      get('/api/search.json', params: { city: city })

      parsed_response = JSON.parse(response.body)
      hotel_names = parsed_response.map { |hotel| hotel['display_name'] }

      expect(hotel_names).to contain_exactly('Hotel Pils', 'Kaķis', 'Sigulda', 'Kaķu māja')
    end

    it 'returns hotels filtered by query without a city' do
      get('/api/search.json', params: { q: query })

      parsed_response = JSON.parse(response.body)
      hotel_names = parsed_response.map { |hotel| hotel['display_name'] }

      expect(hotel_names).to include('Hotel Pils')
    end

    it 'returns all hotels when no params are provided' do
      get('/api/search.json')

      parsed_response = JSON.parse(response.body)
      hotel_names = parsed_response.map { |hotel| hotel['display_name'] }

      expect(hotel_names).to contain_exactly('Hotel Pils', 'Kaķis', 'Sigulda', 'Kaķu māja')
    end
  end
end
