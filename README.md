# docker-cic
Provides builds for cic-domain image


## cic-domain
This build extends the ch-weblogic image and adds a WebLogic domain configuration for the Community Interest Companies (CIC) application.  The image produced by this build can be run, but it is not of practical value and is designed to be further extended by the cic-app build/image.

The domain is simple and comprises:
 - Administration server - (intended to run in wladmin container)
 - Two managed servers & nodemanager - (intended to run in wlserver1 & wlserver2 containers)
 - Datasource for CIC database

### Building the image
To build the image, from the root of the repo run:

    docker build -t cic-domain --build-arg ADMIN_PASSWORD=security123 cic-domain/

**Important** The arg ADMIN_PASSWORD sets the administrator password that is used in the built image.  The password can easily be discovered simply by running `docker history cic-domain` Therefore, the password must be reset, along with other sensitive credentials when the image is actually used to start containers.

### Run time environment properties file
In order to use the image, a number of environment properties need to be defined in a file, held locally to where the docker command is being run - for example, `cic.properties` 
|Property|Description  |Example
|--|--|--
|ADMIN_PASSWORD |The password to set for the weblogic user.  Needs to be at least 8 chars and include a number.|secret123
|DOMAIN_CREDENTIAL|A random string to override and reset the default credential already present in the image.|kjsdgf5464fdva
|LDAP_CREDENTIAL|A random string to override and reset the default credential already present in the image.|ldap01234
|DB_URL|Full JDBC connection string of database|jdbc:oracle:thin:@cicspoc.blahblah.eu-west-2.rds.amazonaws.com:1521:cics
|DB_USER|Database username|CICDBUSER
|DB_PASSWORD|Database passwrod|cicdbpassword
|START_ARGS|Any startup JVM arguments that should be used when starting the managed server|-Dmyarg=true -Dmyotherarg=false
|USER_MEM_ARGS|JVM arguments for setting the GC and memory settings for the managed server.  These will be included at the start of the arguments to the JVM|-XX:+UseG1GC -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xms712m -Xmx712m
|ADMIN_MEM_ARGS|JVM arguments for setting the GC and memory settings for the admin server.  These will be included at the start of the arguments to the JVM|-Djava.security.egd=file:/dev/./urandom -Xms32m -Xmx512m
|AD_HOST|The hostname or ip of the Active Directory server against which to authenticate users|ldap99.domain.ch
|AD_PORT|The port to use for a SSL connection|636
|AD_PRINCIPAL|The user in AD for connecting in order to authenticate other user logins|CN=myldpauser, OU=AD Groups, OU=MySection, OU=MyOrg, DC=MyDepartment, DC=local
|AD_CREDENTIAL|The password of the user in AD for connecting in order to authenticate other user logins|password
|AD_USER_BASE_DN|The base location under which users can be found via a subtree search|OU=MySection, OU=MyOrg, DC=MyDepartment, DC=local
|AD_GROUP_BASE_DN|The base location under which groups can be found via a subtree search|OU=MySection, OU=MyOrg, DC=MyDepartment, DC=local
|AUTO_START_NODES|A list of managed server names to auto start when the container is launched|wlserver1,wlserver2

## docker-compose
docker-compose can be used to start all the required containers in one operation.

It uses the docker-compose.yml file included in the repository to start up the following:
- Apache container
- WebLogic Administration server container
- Two managed server/nodemanager containers

### Preparing for running

The following steps should be taken before first starting the containers with docker-compose

#### Environment variables
In order to configure which version of the images to use when starting, there are two environment variables that can be set:
|ENV VAR  | Description | Example| Default
|--|--|--|--
|CIC_APACHE_IMAGE|The image repository and version to use for the cic-apache image|12345678910.dkr.ecr.eu-west-2.amazonaws.com/cic-apache:1.0|cic-apache (latest local image)
|CIC_APP_IMAGE  |The image repository and version to use for the cic-app image  |12345678910.dkr.ecr.eu-west-2.amazonaws.com/cic-app:1.0|cic-app (latest local image)

#### Properties file for application
In addition, the CIC.properties file described under "Run time environment properties file" also needs to be present.

#### running-servers directory
Finally, the Apache logs and WebLogic managed server work directories are made available to, and persisted, on the host via a bind mount to a local directory.  To create the directory run the following in the root of the checked out repository:

    mkdir -p running-servers/apache

### Starting up
The following command, executed from the root of the repo,  can be used to start up all the containers required to run the CIC service:

    docker-compose up -d


### Accessing the Administration server
After starting the containers, the Administration server console will be available on http://127.0.0.1:21001/console on the host.  You can login with the user `weblogic` and the password you set for `ADMIN_PASSWORD`in the properties file.

### Starting the Managed servers 
The managed server containers will be running Node Manager, which can then be used to start up the managed server instances inside the containers using the Administration console.  If the `AUTO_START_NODES` property is used, the servers listed will be started automatically.
