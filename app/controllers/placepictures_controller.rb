class PlacepicturesController < ApplicationController
  before_action :set_placepicture, only: [:show, :edit, :update, :destroy]

  # GET /placepictures
  # GET /placepictures.json
  def index
    @placepictures = Placepicture.all
  end

  # GET /placepictures/1
  # GET /placepictures/1.json
  def show
  end

  # GET /placepictures/new
  def new
    @placepicture = Placepicture.new
  end

  # GET /placepictures/1/edit
  def edit
  end

  # POST /placepictures
  # POST /placepictures.json
  def create
    @placepicture = Placepicture.new(placepicture_params)

    respond_to do |format|
      if @placepicture.save
        format.html { redirect_to @placepicture, notice: 'Placepicture was successfully created.' }
        format.json { render :show, status: :created, location: @placepicture }
      else
        format.html { render :new }
        format.json { render json: @placepicture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /placepictures/1
  # PATCH/PUT /placepictures/1.json
  def update
    respond_to do |format|
      if @placepicture.update(placepicture_params)
        format.html { redirect_to @placepicture, notice: 'Placepicture was successfully updated.' }
        format.json { render :show, status: :ok, location: @placepicture }
      else
        format.html { render :edit }
        format.json { render json: @placepicture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /placepictures/1
  # DELETE /placepictures/1.json
  def destroy
    @placepicture.destroy
    respond_to do |format|
      format.html { redirect_to placepictures_url, notice: 'Placepicture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_placepicture
      @placepicture = Placepicture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def placepicture_params
      params.fetch(:placepicture, {})
    end
end
