class NominatimService
  BASE_URL = ENV.fetch('NOMINATIM_API_URL', 'http://nominatim:8080')
  HOTELS_QUERY = '/search?q=Hotels%20in%20'.freeze
  FORMAT_PARAM = '&format=json'.freeze

  def self.search_hotels_in_city(city_name)
    encoded_city_name = URI.encode_www_form_component(city_name)
    uri = URI("#{BASE_URL}#{HOTELS_QUERY}#{encoded_city_name}#{FORMAT_PARAM}")
    response = Net::HTTP.get_response(uri)
    return [] unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse response from Nominatim: #{e.message}"
    []
  end
end
