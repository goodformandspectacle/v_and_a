class MaterialThing < ActiveRecord::Base
  belongs_to :material
  belongs_to :thing
end
