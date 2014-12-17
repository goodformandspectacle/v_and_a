class TechniquesController < ApplicationController
  caches_action :index, :cache_path => Proc.new {|c| c.request.url }
  caches_action :show, :cache_path => Proc.new {|c| c.request.url }

  def index
    @technique_things = TechniqueThing.joins(:technique).group("techniques.id").select("techniques.id, techniques.name, count(*) as count").order('count desc').paginate(page: params[:page])
  end

  def show
    @technique = Technique.find_by(name: params[:id])
    @technique_things = TechniqueThing.joins(:thing).where(technique_id: @technique.id).paginate(page: params[:page])
  end
end
