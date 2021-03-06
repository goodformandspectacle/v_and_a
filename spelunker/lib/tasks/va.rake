require 'csv'
require 'oily_png'

class Numeric
  def scale_between(from_min, from_max, to_min, to_max)
    ((to_max - to_min) * (self - from_min)) / (from_max - from_min) + to_min
  end
end

namespace :va do
  # you almost certainly don't want to do this. It will take an age.
  desc 'generate all derived tables for normalization'
  task :generate_all => [:generate_places, :generate_mts, :generate_materials, :generate_techniques, :generate_artists]

  desc 'generate places'
  task :generate_places => [:generate_places_csv, :ingest_places_csv]

  task :generate_places_csv => :environment do
    # make these conditional
    system 'rm places.csv' if File.exists? 'places.csv'
    system 'rm place_things.csv' if File.exists? 'place_things.csv'
    places = []
    place_things = []
    bar = ProgressBar.create(:title => "Places", 
                             :starting_at => 0, 
                             :total => Thing.all.count,
                             :format => '%a |%b>>%i| %p%% %t')
    Thing.find_each do |thing|
      next if thing.place.blank?
      if !places.include?(thing.place)
        places << thing.place
      end

      place_things[thing.id] = places.index(thing.place)

      bar.increment
    end
    bar.finish

    puts "places is #{places.length} long"
    puts "place_things is #{place_things.length} long"

    puts "Making places.csv"
    CSV.open("places.csv", "wb") do |csv|
      places.each_with_index do |place, index|
        csv << [index+1,place]
      end
    end

    # make place_things.csv
    puts "Making place_things.csv"
    CSV.open("place_things.csv", "wb") do |csv|
      place_things.each_with_index do |place, index|
        if place
          csv << [place+1, index]
        end
      end
    end
  end

  task :ingest_places_csv => :environment do
    puts "Deleting old places"
    Place.delete_all
    puts "Ingesting places from CSV"
    ActiveRecord::Base.connection.execute("
      LOAD DATA LOCAL INFILE '#{Dir.pwd}/places.csv'
      INTO TABLE places
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY '\"'
      (id, name);")

    puts "Deleting old placethings"
    PlaceThing.delete_all
    puts "Ingesting place_things from CSV"
    ActiveRecord::Base.connection.execute("
      LOAD DATA LOCAL INFILE '#{Dir.pwd}/place_things.csv'
      INTO TABLE place_things
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY '\"'
      (place_id, thing_id);")
  end

  desc 'generate material_techniques'
  task :generate_mts => [:generate_mts_csv, :ingest_mts_csv]

  task :generate_mts_csv => :environment do
    # make these conditional
    system 'rm mts.csv' if File.exists? 'mts.csv'
    system 'rm mt_things.csv' if File.exists? 'mt_things.csv'
    mts = []
    mt_things = []
    bar = ProgressBar.create(:title => "M&Ts", 
                             :starting_at => 0, 
                             :total => Thing.all.count,
                             :format => '%a |%b>>%i| %p%% %t')
    Thing.find_each do |thing|
      next if thing.materials_techniques.blank?
      if !mts.include?(thing.materials_techniques)
        mts << thing.materials_techniques
      end

      mt_things[thing.id] = mts.index(thing.materials_techniques)

      bar.increment
    end
    bar.finish

    puts "mts is #{mts.length} long"
    puts "mt_things is #{mt_things.length} long"

    puts "Making mts.csv"
    CSV.open("mts.csv", "wb") do |csv|
      mts.each_with_index do |mt, index|
        csv << [index+1,mt]
      end
    end

    # make mt_things.csv
    puts "Making mt_things.csv"
    CSV.open("mt_things.csv", "wb") do |csv|
      mt_things.each_with_index do |mt, index|
        if mt
          csv << [mt+1, index]
        end
      end
    end
  end

  task :ingest_mts_csv => :environment do
    puts "Deleting old material_techniques"
    MaterialTechnique.delete_all
    puts "Ingesting material_techniques from CSV"
    ActiveRecord::Base.connection.execute("
      LOAD DATA LOCAL INFILE '#{Dir.pwd}/mts.csv'
      INTO TABLE material_techniques
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY '\"'
      (id, name);")

    puts "Deleting old material_technique_things"
    MaterialTechniqueThing.delete_all
    puts "Ingesting material_technique_things from CSV"
    ActiveRecord::Base.connection.execute("
      LOAD DATA LOCAL INFILE '#{Dir.pwd}/mt_things.csv'
      INTO TABLE material_technique_things
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY '\"'
      (material_technique_id, thing_id);")
  end

  desc 'generate materials'
  task :generate_materials => [:generate_materials_csv, :ingest_materials_csv]

  task :generate_materials_csv => :environment do
    # make these conditional
    system 'rm materials.csv' if File.exists? 'materials.csv'
    system 'rm material_things.csv' if File.exists? 'material_things.csv'
    materials = []
    material_things = []
    bar = ProgressBar.create(:title => "Mats", 
                             :starting_at => 0, 
                             :total => Thing.all.count,
                             :format => '%a |%b>>%i| %p%% %t')
    Thing.find_each do |thing|
      next if thing['materials'].blank?
      if !materials.include?(thing['materials'])
        materials << thing['materials']
      end

      material_things[thing.id] = materials.index(thing['materials'])

      bar.increment
    end
    bar.finish

    puts "materials is #{materials.length} long"
    puts "material_things is #{material_things.length} long"

    puts "Making materials.csv"
    CSV.open("materials.csv", "wb") do |csv|
      materials.each_with_index do |mt, index|
        csv << [index+1,mt]
      end
    end

    # make material_things.csv
    puts "Making material_things.csv"
    CSV.open("material_things.csv", "wb") do |csv|
      material_things.each_with_index do |mt, index|
        if mt
          csv << [mt+1, index]
        end
      end
    end
  end

  task :ingest_materials_csv => :environment do
    puts "Deleting old materials"
    Material.delete_all
    puts "Ingesting materials from CSV"
    ActiveRecord::Base.connection.execute("
      LOAD DATA LOCAL INFILE '#{Dir.pwd}/materials.csv'
      INTO TABLE materials
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY '\"'
      (id, name);")

    puts "Deleting old material_things"
    MaterialThing.delete_all
    puts "Ingesting material_things from CSV"
    ActiveRecord::Base.connection.execute("
      LOAD DATA LOCAL INFILE '#{Dir.pwd}/material_things.csv'
      INTO TABLE material_things
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY '\"'
      (material_id, thing_id);")
  end

  desc 'generate techniques'
  task :generate_techniques => [:generate_techniques_csv, :ingest_techniques_csv]

  task :generate_techniques_csv => :environment do
    # make these conditional
    system 'rm techniques.csv' if File.exists? 'techniques.csv'
    system 'rm technique_things.csv' if File.exists? 'technique_things.csv'
    techniques = []
    technique_things = []
    bar = ProgressBar.create(:title => "Techniques", 
                             :starting_at => 0, 
                             :total => Thing.all.count,
                             :format => '%a |%b>>%i| %p%% %t')
    Thing.find_each do |thing|
      next if thing['techniques'].blank?
      if !techniques.include?(thing['techniques'])
        techniques << thing['techniques']
      end

      technique_things[thing.id] = techniques.index(thing['techniques'])

      bar.increment
    end
    bar.finish

    puts "techniques is #{techniques.length} long"
    puts "technique_things is #{technique_things.length} long"

    puts "Making techniques.csv"
    CSV.open("techniques.csv", "wb") do |csv|
      techniques.each_with_index do |tech, index|
        csv << [index+1,tech]
      end
    end

    # make technique_things.csv
    puts "Making technique_things.csv"
    CSV.open("technique_things.csv", "wb") do |csv|
      technique_things.each_with_index do |tech, index|
        if tech
          csv << [tech+1, index]
        end
      end
    end
  end

  task :ingest_techniques_csv => :environment do
    puts "Deleting old techniques"
    Technique.delete_all
    puts "Ingesting techniques from CSV"
    ActiveRecord::Base.connection.execute("
      LOAD DATA LOCAL INFILE '#{Dir.pwd}/techniques.csv'
      INTO TABLE techniques
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY '\"'
      (id, name);")

    puts "Deleting old technique_things"
    TechniqueThing.delete_all
    puts "Ingesting technique_things from CSV"
    ActiveRecord::Base.connection.execute("
      LOAD DATA LOCAL INFILE '#{Dir.pwd}/technique_things.csv'
      INTO TABLE technique_things
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY '\"'
      (technique_id, thing_id);")
  end

  desc 'generate artists'
  task :generate_artists => [:generate_artists_csv, :ingest_artists_csv]

  task :generate_artists_csv => :environment do
    # make these conditional
    system 'rm artists.csv' if File.exists? 'artists.csv'
    system 'rm artist_things.csv' if File.exists? 'artist_things.csv'
    artists = []
    artist_things = []
    bar = ProgressBar.create(:title => "Artists", 
                             :starting_at => 0, 
                             :total => Thing.all.count,
                             :format => '%a |%b>>%i| %p%% %t')
    Thing.find_each do |thing|
      next if thing['artist'].blank?
      if !artists.include?(thing['artist'])
        artists << thing['artist']
      end

      artist_things[thing.id] = artists.index(thing['artist'])

      bar.increment
    end
    bar.finish

    puts "artists is #{artists.length} long"
    puts "artist_things is #{artist_things.length} long"

    puts "Making artists.csv"
    CSV.open("artists.csv", "wb") do |csv|
      artists.each_with_index do |art, index|
        csv << [index+1,art]
      end
    end

    # make artist_things.csv
    puts "Making artist_things.csv"
    CSV.open("artist_things.csv", "wb") do |csv|
      artist_things.each_with_index do |art, index|
        if art
          csv << [art+1, index]
        end
      end
    end
  end

  task :ingest_artists_csv => :environment do
    puts "Deleting old artists"
    Artist.delete_all
    puts "Ingesting artists from CSV"
    ActiveRecord::Base.connection.execute("
      LOAD DATA LOCAL INFILE '#{Dir.pwd}/artists.csv'
      INTO TABLE artists
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY '\"'
      (id, name);")

    puts "Deleting old artist_things"
    ArtistThing.delete_all
    puts "Ingesting artist_things from CSV"
    ActiveRecord::Base.connection.execute("
      LOAD DATA LOCAL INFILE '#{Dir.pwd}/artist_things.csv'
      INTO TABLE artist_things
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY '\"'
      (artist_id, thing_id);")
  end


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
