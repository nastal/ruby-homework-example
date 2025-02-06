class WarmupHotelsJob < ApplicationJob
  queue_as :default

  def perform
    City.find_each do |city|

      hotels_data = NominatimService.search_hotels_in_city(city.name)

      ActiveRecord::Base.transaction do

        Hotel.where.not(place_id: hotels_data.map { |hotel_data| hotel_data['place_id'] }).delete_all

        Hotel.upsert_all(hotels_data.map do |hotel_data|
          {
            city_id: city.id,
            display_name: hotel_data['display_name'],
            place_id: hotel_data['place_id'],
            created_at: Time.current,
            updated_at: Time.current
          }
        end , unique_by: [:city_id, :place_id])
      end
    end
  rescue StandardError => e
    Rails.logger.error("WarmupHotelsJob failed: #{e.message}")
    raise e
  end
end
