require 'rails_helper'

RSpec.describe WarmupHotelsJob, type: :job do
  let!(:city) { City.create(name: 'Riga') }
  let(:hotels_data) do
    [
      { 'display_name' => 'Hotel One', 'place_id' => 1 },
      { 'display_name' => 'Hotel Two', 'place_id' => 2 },
      { 'display_name' => 'Hotel Three', 'place_id' => 3 },
      { 'display_name' => 'Hotel Four', 'place_id' => 4 },
      { 'display_name' => 'Hotel Five', 'place_id' => 5 },
    ]
  end

  let(:hotels_new_data) do
    [
      { 'display_name' => 'Hotel One', 'place_id' => 1 },
      { 'display_name' => 'Hotel Four', 'place_id' => 4 },
      { 'display_name' => 'Hotel Five', 'place_id' => 5 },
    ]
  end

  before do
    city.hotels.insert_all(hotels_data)
    allow(NominatimService).to receive(:search_hotels_in_city).and_return(hotels_new_data)
  end

  describe '#perform' do
    it 'fetches data from NominatimService for each city' do
      described_class.perform_now
      expect(NominatimService).to have_received(:search_hotels_in_city).with('Riga')
    end

    it 'creates new hotels for the city' do
      expect { described_class.perform_now }.to change { Hotel.count }.from(5).to(3)
      expect(Hotel.pluck(:display_name)).to match_array(['Hotel One', 'Hotel Four', 'Hotel Five'])
      expect(Hotel.pluck(:city_id).uniq).to eq([city.id])
    end

    it 'logs an error if NominatimService raises an exception' do
      allow(Rails.logger).to receive(:error)
      allow(NominatimService).to receive(:search_hotels_in_city).and_raise(StandardError, 'Something went wrong')

      expect { described_class.perform_now }.to raise_error(StandardError, 'Something went wrong')

      expect(Rails.logger).to have_received(:error).with(
        a_string_including('WarmupHotelsJob failed: Something went wrong')
      )
    end

    it 'runs within a database transaction' do
      allow(Hotel).to receive(:upsert_all).and_raise(StandardError, 'Database error')

      expect do
        expect { described_class.perform_now }.to raise_error(StandardError, 'Database error')
      end.not_to(change { Hotel.count })
    end
  end
end
