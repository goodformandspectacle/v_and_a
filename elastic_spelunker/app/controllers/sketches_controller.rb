class Numeric
  def scale_between(from_min, from_max, to_min, to_max)
    ((to_max - to_min) * (self - from_min)) / (from_max - from_min) + to_min
  end
end

class SketchesController < ApplicationController

  def completeness
    set_cache_header(60 * 10)
    
    @hard_cap = 5000
    if params[:start] && params[:end]
      @min_year_start = params[:start].to_i
      @max_year_end = params[:end].to_i

      #things = Thing.where("year_start >= ?", @min_year_start).where("year_end <= ?", @max_year_end).limit(@hard_cap)

      things = Thing.for_date_graph(between: [@min_year_start, @max_year_end], limit: @hard_cap)
    else
      #things = Thing.where("year_start != ''").where("year_end !=''").limit(@hard_cap)
      things = Thing.for_date_graph(limit: @hard_cap)
      @min_year_start = things.min_by {|t| t.year_start.to_i}.year_start.to_i
      @max_year_end = things.max_by {|t| t.year_end.to_i}.year_end.to_i
    end

    rows = []

    things.each do |thing|
      scaled_start = thing.year_start.to_i.scale_between(@min_year_start,@max_year_end+1,0,100)
      scaled_end = (thing.year_end.to_i + 1).scale_between(@min_year_start,@max_year_end+1,0,100)
      scaled_width = scaled_end - scaled_start

      if thing.accession_year
        accession_left = (thing.accession_year - 1852).to_f / (Time.now.year - 1852) * 100
      end

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
           accession_left: accession_left,
           yellowness: "#{yellowness}_yellow",
           thing: thing}
      rows << t
    end
    @rows = rows
  end
end
