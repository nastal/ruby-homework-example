require 'rails_helper'

RSpec.describe WarmupHotelsJob, type: :job do
  let!(:city) { City.create(name: 'Riga') }
  let(:hotels_data) do
    [
      { 'display_name' => 'Hotel One' },
      { 'display_name' => 'Hotel Two' }
    ]
  end

  before do
    allow(NominatimService).to receive(:search_hotels_in_city).and_return(hotels_data)
  end

  describe '#perform' do
    it 'fetches data from NominatimService for each city' do
      described_class.perform_now
      expect(NominatimService).to have_received(:search_hotels_in_city).with('Riga')
    end

    it 'creates new hotels for the city' do
      expect { described_class.perform_now }.to change { Hotel.count }.from(0).to(2)
      expect(Hotel.pluck(:display_name)).to match_array(['Hotel One', 'Hotel Two'])
      expect(Hotel.pluck(:city_id).uniq).to eq([city.id])
    end

    it 'clears the cache for the city before updating' do
      cache_key = "hotels_in_riga"
      Rails.cache.write(cache_key, ['Old Data'])
      expect(Rails.cache.read(cache_key)).to eq(['Old Data'])

      described_class.perform_now

      expect(Rails.cache.read(cache_key)).to be_nil
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
      allow(Hotel).to receive(:insert_all).and_raise(StandardError, 'Database error')

      expect {
        expect { described_class.perform_now }.to raise_error(StandardError, 'Database error')
      }.not_to change { Hotel.count }
    end
  end
end
