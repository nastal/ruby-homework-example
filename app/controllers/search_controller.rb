class SearchController < ApplicationController
  def index
    city_name = params[:city].to_s.capitalize
    query = params[:q].to_s

    cache_key = "search_results/#{city_name}/#{query}"
    hotels = Rails.cache.fetch(cache_key, expires_in: 1.day) do
      search_hotels(city_name, query)
    end

    render json: hotels
  end

  private

  def search_hotels(city_name, query)
    scope = Hotel.includes(:city)

    if city_name.present?
      scope = scope.joins(:city).where(cities: { name: city_name })
    end

    if query.present?
      scope = scope.where('hotels.display_name ILIKE ?', "%#{query}%")
    end

    scope.map do |hotel|
      {
        id: hotel.id,
        display_name: hotel.display_name,
        city: {
          name: hotel.city.name,
          coat_of_arms_url: hotel.city.coat_of_arms_url
        }
      }
    end
  end
end
