class WarmupHotelsJob < ApplicationJob
  queue_as :default

  def perform
    City.find_each do |city|
      ActiveRecord::Base.transaction do
        Hotel.where(city_id: city.id).delete_all

        hotels_data = NominatimService.search_hotels_in_city(city.name)

        Hotel.insert_all(hotels_data.map do |hotel_data|
          {
            city_id: city.id,
            display_name: hotel_data['display_name'],
            created_at: Time.current,
            updated_at: Time.current
          }
        end)
      end
    end
  rescue StandardError => e
    Rails.logger.error("WarmupHotelsJob failed: #{e.message}")
    raise e
  end
end
