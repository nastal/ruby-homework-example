require 'uri'
require 'net/http'

class SearchController < ApplicationController

  def index
    warmup

    q = params[:q] || ''

    search_result = Hotel.all.select{ |i| i.display_name.include? q }

    with_city = search_result.map do |hotel|
      {
        **hotel.attributes,
        city: { name: hotel['city'] },
      }
    end

    render json: with_city
  end

  def warmup
    # Fetch hotels and search inside name

    cities_and_towns = [
      "Daugavpils",
      "Jelgava",
      "Jurmala",
      "Liepaja",
      "Rezekne",
      "Riga",
      "Ventspils",
      "Sigulda",
      "Cesis",
      "Kuldiga",
    ]

    Hotel.destroy_all

    cities_and_towns.each do |city|
      uri = URI("http://nominatim:8080/search?q=Hotels%20in%20#{city}&format=json")
      res = Net::HTTP.get_response(uri)

      @results = res.is_a?(Net::HTTPSuccess) ? JSON.parse(res.body) : []

      @results.each do |result|
        Hotel.create( city: city, display_name: result["display_name"])
      end
    end
  end

end
