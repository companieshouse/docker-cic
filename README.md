# docker-cic
Provides builds for cic-domain and cic-app images


## cic-domain
This build extends the ch-weblogic image and adds a WebLogic domain configuration for the Community Interest Companies (CIC) application.

The domain is simple and comprises:
 - Administration server - (intended to run in wladmin container)
 - Single managed server & nodemanager - (intended to run in wlserver1 container)
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
|USER_MEM_ARGS|JVM arguments for setting the GC and memory settings for the managed server.  These will be included at the start of the arguments to the JVM| -XX:+UseG1GC -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xms712m -Xmx712m

### Docker network
The Administration server container needs to be able to connect with the managed server container, so a common network is required.  Create this by running:

    docker network create --driver bridge cic-net

### Starting the Administration server container
To start the Administration server in a new container, run:

    docker run -d -p 7001:7001 --name wladmin -h wladmin --network cic-net --env-file=cic.properties cic-domain container-scripts/startAdmin.sh

Around 20 secs after starting the container, the Administration server console will be available on http://127.0.0.1:7001/console on the host.  You can login with the user `weblogic` and the password you set for `ADMIN_PASSWORD`in the properties file.

### Starting the Managed server container
To start the managed server container, run:

    docker run -d -p 7002:7001 --name wlserver1 -h wlserver1 --network cic-net --env-file=cic.properties cic-domain container-scripts/startNodeManager.sh

The managed server container will now be running Node Manager, which can then be used to start up the managed server instance inside the container, using the Administration console.

