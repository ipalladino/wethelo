json.extract! user, :id, :username, :lat, :lng, :address, :reputation, :original_ip, :email, :created_at, :updated_at
json.url user_url(user, format: :json)
