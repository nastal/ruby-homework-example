require 'rails_helper'

RSpec.describe NominatimService do
  describe '.search_hotels_in_city' do
    let(:city_name) { 'Riga' }
    let(:valid_response) do
      [
        {
          "place_id" => 679044,
          "name" => "Justus",
          "display_name" => "Justus, 24, Jauniela, Старый город, Latgales apkaime, Рига, LV-1050, Латвия"
        },
        {
          "place_id" => 678726,
          "name" => "Garden Palace",
          "display_name" => "Garden Palace, 28, ул. Грециниеку, Старый город, Latgales apkaime, Рига, LV-1050, Латвия"
        }
      ]
    end

    let(:base_url) { ENV.fetch('NOMINATIM_API_URL', 'http://nominatim:8080') }
    let(:query_url) { "#{base_url}/search?q=Hotels%20in%20#{URI.encode_www_form_component(city_name)}&format=json" }

    context 'when the response is successful' do
      before do
        stub_request(:get, query_url)
          .to_return(status: 200, body: valid_response.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns parsed hotel data' do
        result = NominatimService.search_hotels_in_city(city_name)
        expect(result).to be_an(Array)
        expect(result.size).to eq(2)
        expect(result.first['name']).to eq('Justus')
        expect(result.first['display_name']).to include('Justus')
      end
    end

    context 'when the response is not successful' do
      before do
        stub_request(:get, query_url)
          .to_return(status: 500, body: '')
      end

      it 'returns an empty array' do
        result = NominatimService.search_hotels_in_city(city_name)
        expect(result).to eq([])
      end
    end

    context 'when the response body is invalid JSON' do
      before do
        stub_request(:get, query_url)
          .to_return(status: 200, body: 'invalid json')
      end

      it 'logs an error and returns an empty array' do
        allow(Rails.logger).to receive(:error)

        result = NominatimService.search_hotels_in_city(city_name)
        expect(result).to eq([])

        expect(Rails.logger).to have_received(:error).with(
          a_string_including('Failed to parse response from Nominatim')
        )
      end
    end

  end
end
