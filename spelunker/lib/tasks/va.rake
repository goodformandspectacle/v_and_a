require 'oily_png'

class Numeric
  def scale_between(from_min, from_max, to_min, to_max)
    ((to_max - to_min) * (self - from_min)) / (from_max - from_min) + to_min
  end
end

namespace :va do
  desc 'spit out a data file for gnuplot'
  task :test_plot => :environment do
    width = 2000

    things = Thing.where("year_start != ''").where("year_end !=''").limit(10000)
    min_year_start = things.min_by {|t| t.year_start.to_i}.year_start.to_i
    max_year_end = things.max_by {|t| t.year_end.to_i}.year_end.to_i

    pixels = []
    count = 0

    things.each_with_index do |thing,y|
      scaled_start = thing.year_start.to_i.scale_between(min_year_start,max_year_end,0,width)
      scaled_end = thing.year_end.to_i.scale_between(min_year_start,max_year_end,0,width)

      row = []
      (0..width-1).each do |x|
        count +=1
        if (x >= scaled_start) && (x <= scaled_end)
          #row << ChunkyPNG::Color.rgba(255,0,0,(thing.completeness * 255).floor)
          if thing.completeness > 0.65
            redness = 255
          elsif thing.completeness > 0.5
            redness = 128
          elsif thing.completeness > 0.35
            redness = 72
          else
            redness = 0
          end
          row << ChunkyPNG::Color.rgba(redness,0,0,255)
        else
          row << ChunkyPNG::Color.rgba(0,0,0,255)
        end
      end
      pixels << row
    end

    #plot = Magick::Image.constitute(width, things.count, "RGB", pixels.flatten)
    #plot = Magick::Image.new(width, things.count)
    #plot.store_pixels(0,0, plot.columns, plot.rows, pixels)

    #plot.write 'output.png'
    #
    
    png = ChunkyPNG::Image.new(width, things.count, ChunkyPNG::Color::TRANSPARENT)
    bar = ProgressBar.create(:title => "Pixels", 
                             :starting_at => 0, 
                             :total => things.count*width,
                             :format => '%a |%b>>%i| %p%% %t')

    pixels.each_with_index do |row,y|
      row.each_with_index do |pixel,x|
        png.set_pixel(x,y,pixel)
        bar.increment
      end
    end

    filename = "sketches/#{Time.now.to_i}.png"
    png.save(filename, :interlace => true)
    puts
    puts "Written '#{filename}'"
    puts "#{things.count} objects from #{min_year_start} to #{max_year_end}"
    `open #{filename}`
  end
end
