class Artist < ActiveRecord::Base
  has_many :artist_things
  has_many :things, :through => :artist_things
end
