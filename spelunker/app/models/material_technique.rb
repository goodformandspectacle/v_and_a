class MaterialTechnique < ActiveRecord::Base
  has_many :material_technique_things
  has_many :things, :through => :material_technique_things
end
