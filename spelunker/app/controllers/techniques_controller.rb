class TechniquesController < ApplicationController
  def index
    @technique_things = TechniqueThing.joins(:technique).group(:technique_id).select("techniques.id, techniques.name, count(*) as count").order('count desc').paginate(page: params[:page])
  end

  def show
    @technique = Technique.find_by(name: params[:id])
    @technique_things = TechniqueThing.joins(:thing).where(technique_id: @technique.id).paginate(page: params[:page])
  end
end
