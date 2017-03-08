json.extract! user, :id, :username, :address, :original_ip, :email, :created_at, :updated_at
json.url user_url(user, format: :json)
