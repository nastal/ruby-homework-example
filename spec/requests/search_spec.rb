require 'rails_helper'

RSpec.describe "/search", type: :request do
  it "returns result under 100ms" do
    start_time = Time.now
    get("/api/search.json", params: {city: "Sigulda", q: "Pils"})
    end_time = Time.now

    request_time = end_time - start_time

    expect(request_time.to_f).to be < 0.1 # under 100ms
  end

  let(:expected_result){
    [
      "Hotel Pils, 4B, Pils iela, Sigulda, Siguldas novads, Vidzeme, LV-2150, Latvija",
      "Kaķis, 8A, Pils iela, Sigulda, Siguldas novads, Vidzeme, LV-2150, Latvija",
      "Sigulda, 6, Pils iela, Sigulda, Siguldas novads, Vidzeme, LV-2150, Latvija",
      "Kaķu māja, 8, Pils iela, Sigulda, Siguldas novads, Vidzeme, LV-2150, Latvija",
      # "Ezīša miga, 6, Pilsētas laukums, Ķelšu ciems, Kuldīga, Kuldīgas novads, Kurzeme, LV-3301, Latvija"
    ]
  }

  it "returns all hotels with Pils from Sigulda" do

    get("/api/search.json", params: {city: "Sigulda", q: "Pils"})

    parsed_response = JSON.parse(response.body)
    names = parsed_response.map{|el| el["display_name"]}

    expect(names).to eq(expected_result)
  end
end
