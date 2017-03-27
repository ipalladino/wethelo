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
      votes = @place.votes.where(user_id: current_user.id, votetype: 1)
      if(votes.length == 1)
        puts "Found!"
        v = votes[0]
        if(v.amount == 1)
          puts "already set"
          render json: v, status: :ok, location: @place
          return
        else
          puts "not set, updating"
          v.amount = 1;
          v.save
          render v, status: :ok, location: @place
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
        puts @v.amount
      end
    end

    if @v.save
      render json: @v, status: :ok
    else
      render json: @v, status: :error
    end

    # respond_to do |format|
    #   if @v.save
    #     format.html { redirect_to @place, notice: 'Place was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @place }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @place.errors, status: :unprocessable_entity }
    #   end
    # end
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
          render json: v, status: :ok
          return
        else
          puts "not set, updating"
          v.amount = -1;
          v.save
          render json: v, status: :ok, data: { no_turbolink: true }
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
        puts @v.amount
      end
    end

    if @v.save
      render json: @v, status: :ok
    else
      render json: @v, status: :error
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def vote_params
      params.require(:place).permit(:amount, :user_id, :place_id, :vote_type)
    end
end
