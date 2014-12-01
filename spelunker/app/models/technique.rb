class Technique < ActiveRecord::Base
  has_many :technique_things
  has_many :things, :through => :technique_things
end
