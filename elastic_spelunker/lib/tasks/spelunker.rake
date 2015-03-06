require 'progressbar'

namespace :spelunker do
  desc "Full ingest: delete index, create index, ingest things"
  task full_ingest: [:drop_index, :create_index, :bulk_ingest_things]

  desc "Delete the index"
  task drop_index: :environment do
    puts "Dropping index."
    `curl -XDELETE 'http://localhost:9200/#{Thing::INDEX_NAME}/'`
  end


  desc "Create index and supply mapping."
  task create_index: :environment do
    puts "Creating index"
    Dir.chdir(Rails.root) do
      `curl -XPUT 'http://localhost:9200/#{Thing::INDEX_NAME}/' -d @mapping.json`
    end
  end

  desc "Ingest things from original SQL file"
  task ingest_things: :environment do
    client = Elasticsearch::Client.new(
      hosts: ['http://localhost:9200']
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
      hosts: ['http://localhost:9200']
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
end
