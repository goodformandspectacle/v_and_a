client = Elasticsearch::Client.new(
  hosts: ['http://46b83eeea46bc4f9000.qbox.io/']
)

RawThing.find_in_batches(batch_size: 1000) do |things|
  things.each do |thing|
    doc = RawThingSerializer.new(thing, root:false).to_json
    client.index(index: 'things', type: 'thing', body: doc)
  end
  print "M"
end
puts
