class PlaceThing < ActiveRecord::Base
  belongs_to :place
  belongs_to :thing
end
