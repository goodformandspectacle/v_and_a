require 'progressbar'

namespace :spelunker do
  desc "Full ingest: delete index, create index, ingest things"
  task full_ingest: [:drop_index, :create_index, :bulk_ingest_things]

  desc "Delete the index"
  task drop_index: :environment do
    puts "Dropping index."
    `curl -XDELETE '#{ELASTICSEARCH_HOST}/#{Thing::INDEX_NAME}/'`
  end


  desc "Create index and supply mapping."
  task create_index: :environment do
    puts "Creating index"
    Dir.chdir(Rails.root) do
      `curl -XPUT '#{ELASTICSEARCH_HOST}/#{Thing::INDEX_NAME}/' -d @mapping.json`
    end
  end

  desc "Ingest things from original SQL file"
  task ingest_things: :environment do
    client = Elasticsearch::Client.new(
      hosts: [ELASTICSEARCH_HOST]
    )

    RawThing.find_in_batches(batch_size: 1000) do |things|
      things.each do |thing|
        doc = RawThingSerializer.new(thing, root:false).to_json
        client.index(index: 'va_things', type: 'thing', body: doc)
      end
      print "M"
    end
    puts
  end

  desc "Ingest things from original SQL file using Bulk api"
  task bulk_ingest_things: :environment do
    client = Elasticsearch::Client.new(
      hosts: [ELASTICSEARCH_HOST]
    )

    pbar = ProgressBar.new("Ingesting things", RawThing.all.count / 1000.0)

    RawThing.find_in_batches(batch_size: 1000) do |things|
      # make an array of docs
      thing_docs = things.map do |thing|
        doc = RawThingSerializer.new(thing, root:false)
      end

      #now make that array a bulk array
      bulk_array = thing_docs.map do |thing_doc|
        { index: { _index: "#{Thing::INDEX_NAME}", _type: 'thing', data: thing_doc } }
      end

      client.bulk body: bulk_array
      pbar.inc
    end
    pbar.finish
  end

  desc "Export JSON of raw data (requires ~ 2gig of disk space)"
  task json_export: :environment do
    pbar = ProgressBar.new("Exporting", RawThing.all.count / 1000.0)

    dirname = Rails.root.join('json_data')
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end

    i = 1000
    RawThing.find_in_batches(batch_size: 1000) do |things|
      # make an array of docs
      thing_docs = things.map do |thing|
        doc = RawThingSerializer.new(thing, root:false)
      end
      File.open(Rails.root.join("json_data", "#{i}.json"), 'w') do |f|
        f.write(thing_docs.to_json)
      end
      pbar.inc
      i += 1000
    end
    pbar.finish
  end
end
