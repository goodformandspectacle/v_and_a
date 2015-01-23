class ArtistsController < ApplicationController
  caches_action :index, cache_path: Proc.new {|c| c.request.url }, expires_in: 1.week
  caches_action :show, cache_path: Proc.new {|c| c.request.url }, expires_in: 1.week

  def index
    @artist_things = ArtistThing.joins(:artist).group("artists.id").select("artists.id, artists.name, count(*) as count").order('count desc').paginate(page: params[:page])
  end

  def show
    @artist = Artist.find_by(name: params[:id])
    @count = ArtistThing.joins(:thing).where(artist_id: @artist.id).count
    @artist_things = ArtistThing.joins(:thing).where(artist_id: @artist.id).paginate(page: params[:page])
  end
end
