namespace :spelunker do
  desc "Full ingest: delete index, create index, ingest things"
  task full_ingest: [:drop_index, :create_index, :ingest_things]

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

end
