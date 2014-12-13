class PlacesController < ApplicationController
  def index
    @placethings = PlaceThing.joins(:place).group("places.id").select("places.id, places.name, count(*) as count").order('count desc').paginate(page: params[:page])
  end

  def show
    @place = Place.find_by(name: params[:id])
    @placethings = PlaceThing.joins(:thing).where(place_id: @place.id).paginate(page: params[:page])
  end
end
