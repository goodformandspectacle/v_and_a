class Place < ActiveRecord::Base
  has_many :place_things
  has_many :things, :through => :place_things
end
