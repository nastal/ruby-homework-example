class WarmupHotelsJob < ApplicationJob
  queue_as :default

  def perform
    City.find_each do |city|
      # Heat cache before process so API remain hydrated
      cache_key = "hotels_in_#{city.name.downcase}"
      Rails.cache.write(cache_key, city.hotels.to_a, expires_in: 10.minutes)

      ActiveRecord::Base.transaction do

        Hotel.where(city_id: city.id).delete_all

        hotels_data = NominatimService.search_hotels_in_city(city.name)

        Hotel.insert_all(hotels_data.map { |hotel_data|
          {
            city_id: city.id,
            display_name: hotel_data['display_name'],
            created_at: Time.current,
            updated_at: Time.current
          }
        })
      end

      Rails.cache.delete(cache_key)
    end
  rescue => e
    Rails.logger.error("WarmupHotelsJob failed: #{e.message}")
    raise e
  end
end
