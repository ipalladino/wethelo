if user_signed_in?
  user_id = current_user.id
  if(place.votes.where(user_id: user_id, votetype: 0).length == 1)
    user_recommended = true
  else
    user_recommended = false
  end

  v = place.votes.where(user_id: user_id, votetype: 1)
  if(v.length == 1)
    amount = v[0].amount
    if(amount != nil)
      liked_status = amount
    else
      liked_status = 0;
    end
  else
    liked_status = 0
  end
end


json.extract! place, :id, :title, :description, :recommendations, :votes, :lat, :recommendations, :address, :placepictures, :lng, :created_at, :updated_at
json.url place_url(place, format: :json)
json.user_recommended user_recommended
json.liked_status liked_status
