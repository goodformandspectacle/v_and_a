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

In production, we use the [AWS Elasticsearch Service][awses], with access limited to a particular IAM user (as well as developers' IP addresses). This is configured in `config/environments/production.rb` with a global variable (`USE_AWS_ES`), and via a series of environment variables: `AWS_ID`, `AWS_SECRET`, and `ELASTICSEARCH_HOST`.

The AWS_ID and AWS_SECRET variables are the key and secret for a particular Amazon IAM user, that's been granted access to the Elasticsearch server via the AWS control panel (as part of the process of creating the ES server). We use IAM security as the application is running on Heroku, which cannot guarantee us a fixed IP address; otherwise, we could just use Amazon's fixed IP security.

If `USE_AWS_ES` is set, the application will sign every request to elasticsearch with the IAM key and secret. We do this using a Faraday middleware called [`faraday_middleware-aws-signers-v4`][middleware], which performs this for us on each Elasticsearch request, and is configured inside `app/models/thing.rb`

[awses]:https://aws.amazon.com/elasticsearch-service/
[middleware]:https://github.com/winebarrel/faraday_middleware-aws-signers-v4