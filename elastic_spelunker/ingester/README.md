# Ingester

The ingester is a quick tool to hurl JSON data from the V&A dataset into an
Elasticsearch database. (This means you can upload data without having to
install MySQL).

Usage is:

  ./ingester.rb {json_dir} {index_name} {hostname}

where `json_dir` is a directory full of V&A JSON files, `index_name` is the
index you wish to insert into, and `hostname` is the host of the Elasticsearch
box.

## JSON Files

JSON is generate from a local spelunker install, with the V&A MySQL dataset
available, via `rake spelunker:export_json`. This uses about 2.2gb on disk.

## Installation

Stick the JSON directory, the mapping.json for the schema, and the ingester
tool onto a server of your choosing. `bundle install` will install
dependencies.
