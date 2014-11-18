class Numeric
  def scale_between(from_min, from_max, to_min, to_max)
    ((to_max - to_min) * (self - from_min)) / (from_max - from_min) + to_min
  end
end

class SketchesController < ApplicationController
  def completeness
    width = 960
    if params[:start] && params[:end]
      things = Thing.where("year_start > ?", params[:start].to_i).where("year_end <= ?", params[:end].to_i).limit(10000)
    else
      things = Thing.where("year_start != ''").where("year_end !=''").limit(10000)
    end
    @min_year_start = things.min_by {|t| t.year_start.to_i}.year_start.to_i
    @max_year_end = things.max_by {|t| t.year_end.to_i}.year_end.to_i

    rows = []

    things.each do |thing|
      scaled_start = thing.year_start.to_i.scale_between(@min_year_start,@max_year_end,0,width)
      scaled_end = thing.year_end.to_i.scale_between(@min_year_start,@max_year_end,0,width)
      scaled_width = scaled_end - scaled_start

      if thing.completeness > 0.65
        yellowness = 'very'
      elsif thing.completeness > 0.5
        yellowness = 'quite'
      elsif thing.completeness > 0.35
        yellowness = 'little'
      else
        yellowness = 'not'
      end

      t = {start: scaled_start,
           width: scaled_width,
           yellowness: "#{yellowness}_yellow",
           thing: thing}
      rows << t
    end
    @rows = rows
  end
end
