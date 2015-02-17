namespace :spelunker do
  desc "Ingest things from original SQL file"
  task :ingest_things => :environment do
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
