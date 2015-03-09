#! /usr/bin/env ruby

require 'elasticsearch'
require 'progressbar'
require 'json'

# iterate over the files in JSON_DIR and throw them at INDEX on HOSTNAME

unless ARGV.length == 3
  puts "Usage: ingester.rb json_dir index_name hostname"
  exit
end

json_dir, index_name, hostname = ARGV[0], ARGV[1], ARGV[2]

client = Elasticsearch::Client.new(
  hosts: [hostname]
)

thing_count = Dir["#{json_dir}/*.json"].size
pbar = ProgressBar.new("Ingesting things", thing_count)

Dir["#{json_dir}/*.json"].each do |json_filename|
  # get an array of objects
  thing_docs = JSON.parse(File.read(json_filename))

  bulk_array = thing_docs.map do |thing_doc|
    { index: { _index: index_name, _type: 'thing', data: thing_doc } }
  end

  client.bulk body: bulk_array
  pbar.inc
end
pbar.finish


