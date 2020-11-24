#!/bin/bash

if [ -z ${ADMIN_PASSWORD+x} ]; then
  echo "Env var ADMIN_PASSWORD must be set! Exiting.."
  exit 1
fi

DOMAIN_HOME="${ORACLE_HOME}/${DOMAIN_NAME}"
. ${DOMAIN_HOME}/bin/setDomainEnv.sh

# Regenerate the demo cert (which NodeManager is currently using) so that it has the correct common name (hostname)
cd ${DOMAIN_HOME}/security
java utils.CertGen -keyfilepass DemoIdentityPassPhrase -certfile democert -keyfile demokey
java utils.ImportPrivateKey -keystore DemoIdentity.jks -storepass DemoIdentityKeyStorePassPhrase -keyfilepass DemoIdentityPassPhrase -certfile democert.pem -keyfile demokey.pem -alias demoidentity

# Update the nodemanager.properties to set the ListenAddress to the current hostname
sed -i 's/ListenAddress=localhost/ListenAddress='${HOSTNAME}'/g' ${DOMAIN_HOME}/nodemanager/nodemanager.properties

# Set the credentials for nodemanager
echo "username=weblogic" > ${DOMAIN_HOME}/config/nodemanager/nm_password.properties
echo "password=${ADMIN_PASSWORD}" >> ${DOMAIN_HOME}/config/nodemanager/nm_password.properties

${DOMAIN_HOME}/bin/startNodeManager.sh $*

