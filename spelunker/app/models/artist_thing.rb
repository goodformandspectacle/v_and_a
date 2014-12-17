class ArtistThing < ActiveRecord::Base
  belongs_to :artist
  belongs_to :thing
end
