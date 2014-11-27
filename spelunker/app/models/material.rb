class Material < ActiveRecord::Base
  has_many :material_things
  has_many :things, :through => :material_things
end
