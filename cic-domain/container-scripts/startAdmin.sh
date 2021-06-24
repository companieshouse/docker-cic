#!/bin/bash

if [ -z ${ADMIN_PASSWORD+x} ]; then
  echo "Env var ADMIN_PASSWORD must be set! Exiting.."
  exit 1
fi

# This is the admin server so we will use different memory args
export USER_MEM_ARGS=${ADMIN_MEM_ARGS}

DOMAIN_HOME="/apps/oracle/${DOMAIN_NAME}"
. ${DOMAIN_HOME}/bin/setDomainEnv.sh

# Set the admin password to the one supplied via env var
java weblogic.security.utils.AdminAccount weblogic $ADMIN_PASSWORD $DOMAIN_HOME/security

# Set up the boot.properties file to allow automatic startup
mkdir -p ${DOMAIN_HOME}/servers/${ADMIN_NAME}/security
echo "username=weblogic" > ${DOMAIN_HOME}/servers/${ADMIN_NAME}/security/boot.properties
echo "password=${ADMIN_PASSWORD}" >> ${DOMAIN_HOME}/servers/${ADMIN_NAME}/security/boot.properties

# Update the domain credentials to those provided by env var
${ORACLE_HOME}/wlserver/common/bin/wlst.sh ${ORACLE_HOME}/container-scripts/set-credentials.py

# Set the cic-jdbc connection string and credentials
${ORACLE_HOME}/wlserver/common/bin/wlst.sh ${ORACLE_HOME}/container-scripts/set-jdbc-details.py

# Set the managed server startup arguments
sed -i "s/@start-args@/${START_ARGS}/g" ${DOMAIN_HOME}/config/config.xml

# Prevent Derby from being started
export DERBY_FLAG=false

${DOMAIN_HOME}/bin/startWebLogic.sh $*
