class PlacesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  #a user can recommend a place only once, it will create a vote entry, relative to user and place
  def recommend
    if !user_signed_in?
      redirect_to "/sign_in", status: 302, data: { no_turbolink: true }
      return
    end

    @place = Place.find(params["id"])

    #if the place is found
    if(@place)
      votes = @place.votes.where(user_id: current_user.id, votetype: 0)
      if(votes.length == 1)
        render json: "{'status' : 'already-voted'}", status: :ok, location: @place
        return
        #user already voted
      elsif (votes.length > 1)
        #user tricked
        logger.fatal "The user voted more than once!"
      else
        #user can vote!
        @v = Vote.new(user_id: current_user.id, place_id: @place.id)
      end
    end

    #if(place.recommendations == nil)
    #  place.recommendations = 1
    #else
    #  place.recommendations = place.recommendations+1;
    #end
    #@place = place

    respond_to do |format|
      if @v.save
        format.html { redirect_to @place, notice: 'Place was successfully updated.' }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove_recommendation
    if !user_signed_in?
      redirect_to "/sign_in", status: 302, data: { no_turbolink: true }
      return
    end

    @place = Place.find(params["id"])

    #if the place is found
    if(@place)
      votes = @place.votes.where(user_id: current_user.id, votetype: 0)
      if(votes.length == 1)
        respond_to do |format|
          if votes[0].destroy
            format.html
            format.json { render :show, status: :ok, location: @place }
          else
            format.html
            format.json { render json: @place.errors, status: :unprocessable_entity }
          end
        end

        return
        #user already voted
      elsif (votes.length > 1)
        #user tricked
        logger.fatal "The user voted more than once!"
      else
        #user can vote!
        #nothing to do
      end
    end

    render json: "{'status' : 'nothing-happened'}", status: :ok, location: @place
    return
  end



  # GET /places
  # GET /places.json
  def index
    @places = Place.all
  end

  # GET /places/1
  # GET /places/1.json
  def show
  end

  # GET /places/new
  def new
    @place = Place.new
  end

  # GET /places/1/edit
  def edit
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(place_params)

    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, notice: 'Place was successfully created.' }
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to @place, notice: 'Place was successfully updated.' }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place.destroy
    respond_to do |format|
      format.html { redirect_to places_url, notice: 'Place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params.require(:place).permit(:title, :description, :lat, :lng, :address)
    end
end
