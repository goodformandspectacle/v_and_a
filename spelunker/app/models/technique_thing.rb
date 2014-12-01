class TechniqueThing < ActiveRecord::Base
  belongs_to :technique
  belongs_to :thing
end
