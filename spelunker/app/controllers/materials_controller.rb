class MaterialsController < ApplicationController
  caches_action :index, cache_path: Proc.new {|c| c.request.url }, expires_in: 1.week
  caches_action :show, caches_path: Proc.new {|c| c.request.url }, expires_in: 1.week

  def index
    @material_things = MaterialThing.joins(:material).group("materials.id").select("materials.id, materials.name, count(*) as count").order('count desc').paginate(page: params[:page])
  end

  def show
    @material = Material.find_by(name: params[:id])
    @count = MaterialThing.joins(:thing).where(material_id: @material.id).count
    @material_things = MaterialThing.joins(:thing).where(material_id: @material.id).paginate(page: params[:page])
  end
end
