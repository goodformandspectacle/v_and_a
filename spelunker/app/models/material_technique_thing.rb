class MaterialTechniqueThing < ActiveRecord::Base
  belongs_to :material_technique
  belongs_to :thing
end
