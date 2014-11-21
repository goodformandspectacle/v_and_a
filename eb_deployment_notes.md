# Spelunker - Elastic Beanstalk deployment notes.

First off: we need a keypair so I can SSH into the server (in order to push the database up). I need to make this before I build the server.

From the EC2 config, I chose keypairs, made a keypair, and got the .pem file. George has a zipfile with this in it.

Next, I made an ElasticBeanstalk application: Ruby on 64-bit Amazon Linux, in an auto-scaling group.

Then, I made a production environment, with which:

* I specified a linked RDS instance
* specified that the EB instance should be t2.micro, using the keypair previously described to access it.
* I specified that RDS should be a t1.micro running mysql
* I made a RDS dbuser: rdsdbuser / arYfCu2k9Jx

Once all that's done, I uploaded a packaged zipfile of the app. I generated it with git archive, but you could also make it by hand. I uploaded that to the server. Of course, that won't work without the database.

To upload the database, I scp'd it to the server. I found the server's address in the EC2 configuration, which was ec2-54-229-37-14.eu-west-1.compute.amazonaws.com . So to SCP the file I ran:

	scp -i ~/.ssh/gfs-developer-key.pem va_collections.sql.tgz ec2-user@ec2-54-229-37-14.eu-west-1.compute.amazonwas.com

which copied the tgz to the server. once it was there, I could SSH in:

	ssh ec2-user@ec2-54-229-37-14.eu-west-1.compute.amazonaws.com -i ~/.ssh/gfs-developer-key.pem

I'm now on the server, where I do two things. Unzip the database:

	tar -zxvf va_collections.sql.tgz

and then load it into the RDS database. All the RDS config is set as environment variables, so I just have to do this:

	mysql -u $RDS_USERNAME -p$RDS_PASSWORD -h $RDS_HOSTNAME $RDS_DB_NAME < va_collections.sql

Once that's loaded, the application should be working.

