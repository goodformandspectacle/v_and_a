class MaterialsTechniquesController < ApplicationController
  def index
    @material_technique_things = MaterialTechniqueThing.joins(:material_technique).group(:material_technique_id).select("material_techniques.id, material_techniques.name, count(*) as count").order('count desc').paginate(page: params[:page])
  end

  def show
    @material_technique = MaterialTechnique.find_by(name: params[:id])
    @material_technique_things = MaterialTechniqueThing.joins(:thing).where(material_technique_id: @material_technique.id).paginate(page: params[:page])
  end
end
