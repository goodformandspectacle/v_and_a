class MaterialsController < ApplicationController
  def index
    @material_things = MaterialThing.joins(:material).group("materials.id").select("materials.id, materials.name, count(*) as count").order('count desc').paginate(page: params[:page])
  end

  def show
    @material = Material.find_by(name: params[:id])
    @material_things = MaterialThing.joins(:thing).where(material_id: @material.id).paginate(page: params[:page])
  end
end
