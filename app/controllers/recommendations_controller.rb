class RecommendationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  #a user can recommend a place only once, it will create a vote entry, relative to user and place
  def like_recommendation
    if !user_signed_in?
      redirect_to "/sign_in", status: 302, data: { no_turbolink: true }
      return
    end

    @place = Place.find(params["id"])

    #if the place is found
    if(@place)
      puts "search for likes of current_user"
      #first we verify on liked/disliked if the user already did it
      votes = @place.votes.where(user_id: current_user.id, votetype: 1)
      if(votes.length == 1)
        #the user already did it
        puts "Found!"
        v = votes[0]
        #lets see if it was possitive
        if(v.amount == 1)
          #it was possitive, nothing to do
          puts "already set"
          render json: @place, status: :ok, location: @place
          return
        else
          #it was negative, we need to update it
          puts "Vote was negative, now its positive, updating"
          v.amount = 1;
          v.save

          puts "WOHOO!! reputation gain for all users who recommended!"
          #we gotta make sure its the only ones that actually RECOMMENDED
          recommendations = @place.votes.where(votetype: 0)
          recommendations.each do |recommendation|
            #we gotta exclude the current_user, as he should not get rep from his own vote
            puts "User #{recommendation.user.username} gets reputation!"
            u = recommendation.user
            if(u.id != current_user.id)
              u.reputation = u.reputation != nil ? u.reputation+1 : 1
              u.save
            end
          end

          @place.calculate_reputation

          render :show, status: :ok, location: @place, template: "places/show"
          return
        end
        #user already voted
      elsif (votes.length > 1)
        #user tricked
        logger.fatal "The user voted more than once!"
      else
        #user can vote!
        puts "user can vote!"
        @v = Vote.new(user_id: current_user.id, place_id: @place.id, votetype: 1, amount: 1)

        puts "WOHOO!! reputation gain for all users who recommended!"
        #we gotta make sure its the only ones that actually RECOMMENDED
        recommendations = @place.votes.where(votetype: 0)
        recommendations.each do |recommendation|
          puts "User #{recommendation.user.username} gets reputation!"
          u = recommendation.user
          if(u.id != current_user.id)
            u.reputation = u.reputation != nil ? u.reputation+1 : 1
            u.save
          end
        end
      end
    end

    @place.calculate_reputation

    if @v.save
      render :show, status: :ok, location: @place, template: "places/show"
    else
      render :show, status: :error, location: @place, template: "places/show"
    end
  end

  def dislike_recommendation
    if !user_signed_in?
      redirect_to "/sign_in", status: 302, data: { no_turbolink: true }
      return
    end

    @place = Place.find(params["id"])

    #if the place is found
    if(@place)
      puts "search for likes of current_user"
      votes = @place.votes.where(user_id: current_user.id, votetype: 1)
      if(votes.length == 1)
        puts "Found!"
        v = votes[0]
        if(v.amount == -1)
          puts "already set"
          render json: @place, status: :ok
          return
        else
          puts "not set, updating"
          v.amount = -1;
          v.save

          puts "WOHOO!! reputation loss for all users who recommended!"
          recommendations = @place.votes.where(votetype: 0)
          recommendations.each do |recommendation|
            puts "User #{recommendation.user.username} gets reputation!"
            u = recommendation.user
            if(u.id != current_user.id)
              u.reputation = u.reputation != nil ? u.reputation-1 : -1
              u.save
            end
          end

          @place.calculate_reputation
          render :show, status: :ok, location: @place, template: "places/show"
          return
        end
        #user already voted
      elsif (votes.length > 1)
        #user tricked
        logger.fatal "The user voted more than once!"
      else
        #user can vote!
        puts "user can vote!"
        @v = Vote.new(user_id: current_user.id, place_id: @place.id, votetype: 1, amount: -1)

        puts "WOHOO!! reputation loss for all users who recommended!"
        recommendations = @place.votes.where(votetype: 0)
        recommendations.each do |recommendation|
          puts "User #{recommendation.user.username} gets reputation!"
          u = recommendation.user
          if(u.id != current_user.id)
            u.reputation = u.reputation != nil ? u.reputation-1 : -1
            u.save
          end
        end
      end
    end

    @place.calculate_reputation
    if @v.save
      render :show, status: :ok, location: @place, template: "places/show"
    else
      render :show, status: :error, location: @place, template: "places/show"
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def vote_params
      params.require(:place).permit(:amount, :user_id, :place_id, :vote_type)
    end
end
