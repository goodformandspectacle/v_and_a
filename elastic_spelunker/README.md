# V&A Elastic Spelunker

A webapp to explore the V&A Collection database - only this time with Elasticsearch.

## Installation

The spelunker is a pretty standard Rails application, with some exceptions.

It expects an elasticsearch instance to run. By default, in *development* this is expected to be `http://localhost:9200` - but you can configure this in `config/environments/development.rb'.

In *production*, you should set your elasticsearch host as an environment variable called `ELASTICSEARCH_HOST`. You can include http basic auth in the URL you set here.

In development, the software also expects a MySQL database. Set up your database in `config/database.yml` and then:

	bundle install

will set up the gems you require.

Don't migrate the database yet!

## Data ingest to MySQL

Now you can ingest the big SQL file into the database. It took… a fair while; it's a 1.2gb uncompressed textfile, and the indexing takes a while.

## Data ingest to Elasticsearch

To get the data into Elasticsearch, there are two methods:

* you could use `rake spelunker:json_export` to spit out about 2gb of JSON to describe the whole dataset, and then use the code in `ingester/` to hurl this at Elasticsearch. In development, you probably don't want to do this. (It's great for pushing the data into a remote elasticsearch instance, though - you can just install it on a server and set it running; `ingester.rb` doesn't require anything like a full Rails instance or mysql, just Rubygems)
* More probably, you could just run `rake spelunker:full_ingest` which will drop the elasticsearch index if it exists, recreate it (applying the `mapping.json` file to it) and then pipe all the MySQL derived objects straight into Elasticsearch

## Running

With all your data in elasticsearch, `rails s` will spin up a local server for you.

## Deployment

The simplest way to deploy the Spelunker is to push the Rails app to a Heroku instance, configure an Elasticsearch box somewhere with the appropriate data, configure the appropraite environment variable on Heroku, and away you go.

`../deploy_elastic_spelunker.sh` is the git subtree invocation to push a subdirectory to Heroku.

I used [qbox](http://qbox.io) to deploy my elasticsearch instance, and the code in `/ingester` to push all the data into qbox, but obviously there are many ways to approach this.