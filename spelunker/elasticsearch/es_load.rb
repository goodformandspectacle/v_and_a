client = Elasticsearch::Client.new(
  hosts: ['http://localhost:9200']
)

RawThing.find_in_batches(batch_size: 1000) do |things|
  things.each do |thing|
    doc = RawThingSerializer.new(thing, root:false).to_json
    client.index(index: 'things', type: 'thing', body: doc)
  end
  print "M"
end
puts
