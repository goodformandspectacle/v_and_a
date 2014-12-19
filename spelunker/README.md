# V&A Spelunker

A webapp to explore the V&A Collection database.

## Installation

The spelunker is a pretty standard Rails application, expecting a MySQL database. Set up your database in `config/database.yml` and then:

	bundle install

will set up the gems you require.

Don't migrate the database yet!

## Data ingest

Now you can ingest the big SQL file into the database. It took… a fair while; it's a 1.2gb uncompressed textfile, and the indexing takes a while.

## Extraneous data migration

Once the data's ingested, you can run `rake db:migrate` to generate the extra, Rails-created table you'll need. We're going to make some join models out of the big single table to speed things up, and then run some rake tasks to populate their tables.

First, make sure you've migrated the DB. Then, from the app's directory, you can just run

	rake va:generate_all
	
(although read the rest of this paragraph before you do so). This will run all the tasks to generate all the data for join models as CSV files and then (hopefully) ingest it via MySQL's `LOAD DATA INFILE`. Most of these take about 10-15 minutes, although `generate_materials_techniques` takes around an hour. (On a i5 Macbook Air with 8GB ram).

In `lib/tasks/va.rake` you'll find the full Rakefile, and you can choose to run individual tasks if you'd like to pace them - either generate/ingest a single type of thing (`rake va:generate_materials`) or go as granular as separating generation and ingest (`rake va:generate_materials_csv` and `rake va:ingest_materials_csv`, for instance).

For deployment, I generated the CSV, `scp`ed it over to the server, and then ingested it there.

## Deployment

We're deploying to Amazon Elastic Beanstalk; George supplied me with creds for the GFS account.

Deployment is relatively straightforward: you need to push a zip of executable code to Amazon Elastic Beanstalk. I've simplified that process a little with a script:

1. Push all your changes to the remote repository
2. From the root directory of the repository, ie, the parent of this directory, run `./package.rb`
3. This will create a zipfile with a name like `rev-855896a.zip`, describing which version of the code has been zipped (and containing the output of `git-archive` for the `spelunker` directory: you have to supply the code with no parent directories at all, and only that which you wish to run - which makes deploying from a subdirectory require this step)
4. From the AWS Elastic Beanstalk control panel, deploy a new version, uploading this zipfile when prompted.