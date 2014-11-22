# Spelunker - Elastic Beanstalk deployment notes.

First off: we need a keypair so I can SSH into the server (in order to push the database up). I need to make this before I build the server.

From the EC2 config, I chose keypairs, made a keypair, and got the .pem file. George has a zipfile with this in it.

Next, I made an ElasticBeanstalk application: Ruby on 64-bit Amazon Linux, in an auto-scaling group.

Then, I made a production environment, with which:

* I specified a linked RDS instance
* specified that the EB instance should be t2.micro, using the keypair previously described to access it.
* I specified that RDS should be a t1.micro running mysql
* I made a RDS dbuser: rdsdbuser / arYfCu2k9Jx

Once all that's done, I need to load the sql file to the database. This is a bit trickier than I realised, because the Elastic Beanstalk services are load-scaling. If I copy the sql file to one of them, and then load it into the database from there (because only servers in the EB security group can connect to RDS), the server might get spun down before it completes.

So we make **another** server for the process of loading the data. In EC2, I make a t2.micro, with the `gds-geveloper-key` keypair, and I stick it in the Elastic Beanstalk security group so it can talk to RDS.

Then, I log into the temporary server, just to check all is OK. Once it is, I scp the compressed sql file to it:

	scp -i ~/.ssh/gfs-developer-key.pem va_collections.sql.tgz ec2-user@[temporary-server-address]

which copied the tgz to the server. once it was there, I could SSH in:

	ssh ec2-user@[temporary-server-address] -i ~/.ssh/gfs-developer-key.pem

I'm now on the server. I unzip the database:

	tar -zxvf va_collections.sql.tgz
	
The file has a capital I as the last line, which is just wrong, so we remove it with `sed`:

	sed -i '$ d' va_collections.sql

Then I need to load it into the RDS database. On the EB server, the database config is all available as environment variables… but we're not on that server! Sigh. So I ssh into the **Elastic Beanstalk** server, and note down what `RDS_USERNAME`, `RDS_PASSWORD`, `RDS_HOSTNAME`, and `RDS_DB_NAME` are. Then, on the temporary server, I can run this:

	mysql -u [username] -p[password] -h [hostname] [dbname] < va_collections.sql
	
(I recommend doing this over `screen`, because it takes ages. Also: make sure the instance has termination protection on).

Once that's loaded, the application should be working. I can destroy the temporary EC2 server used for loading the database.

