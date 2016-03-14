class SightingsController < ApplicationController
  def index
    @sightings = Sighting.all
    @region_options_array = Region.all.map { |r| [r.name, r.id] }
  end

  def new
    @species = Species.find(params[:species_id])
    @sighting = @species.sightings.new
  end

  def create
    @species = Species.find(params[:species_id])
    @sighting = @species.sightings.new(sighting_params)
    if @sighting.save
      redirect_to species_path(@sighting.species)
    else
      render :new
    end
  end

  def edit
    @species = Species.find(params[:species_id])
    @sighting = Sighting.find(params[:id])
  end

  def update
    @species = Species.find(params[:species_id])
    @sighting = Sighting.find(params[:id])
    if @sighting.update(sighting_params)
      redirect_to species_path(@species)
    else
      render :edit
    end
  end

  def destroy
    @species = Species.find(params[:species_id])
    @sighting = Sighting.find(params[:id])
    @sighting.destroy
    redirect_to species_path(@species)
  end

  private

  def sighting_params
    params.require(:sighting).permit(:date, :latitude, :longitude, :region_id)
  end
end
