json.extract! place, :id, :title, :description, :recommendations, :votes, :lat, :lng, :created_at, :updated_at
json.url place_url(place, format: :json)
