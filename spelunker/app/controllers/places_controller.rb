class PlacesController < ApplicationController
  caches_action :index, :cache_path => Proc.new {|c| c.request.url }
  caches_action :show, :cache_path => Proc.new {|c| c.request.url }

  def index
    @placethings = PlaceThing.joins(:place).group("places.id").select("places.id, places.name, count(*) as count").order('count desc').paginate(page: params[:page])
  end

  def show
    @place = Place.find_by(name: params[:id])
    @count = PlaceThing.joins(:thing).where(place_id: @place.id).count
    @placethings = PlaceThing.joins(:thing).where(place_id: @place.id).paginate(page: params[:page])
  end
end
