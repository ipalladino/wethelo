json.extract! vote, :id, :amount, :user_id, :place_id, :created_at, :updated_at
json.url vote_url(vote, format: :json)
