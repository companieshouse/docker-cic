#!/bin/sh

DOMAIN_HOME="/apps/oracle/${DOMAIN_NAME}"
. $DOMAIN_HOME/bin/setDomainEnv.sh

# Remove the LDAP realm info provided by the image
rm -r $DOMAIN_HOME/servers/${ADMIN_NAME}/data

# Set the admin password to the one supplied via env var
java weblogic.security.utils.AdminAccount weblogic $ADMIN_PASSWORD $DOMAIN_HOME/security

# Set the
mkdir -p ${DOMAIN_HOME}/servers/${ADMIN_NAME}/security
echo "username=weblogic" > ${DOMAIN_HOME}/servers/${ADMIN_NAME}/security/boot.properties
echo "password=${ADMIN_PASSWORD}" >> ${DOMAIN_HOME}/servers/${ADMIN_NAME}/security/boot.properties

# Update the domain credentials
$ORACLE_HOME/wlserver/common/bin/wlst.sh ${DOMAIN_HOME}/../container-scripts/set-credentials.py

# Set the cic-jdbc connection string and credentials
$ORACLE_HOME/wlserver/common/bin/wlst.sh ${DOMAIN_HOME}/../container-scripts/set-jdbc-details.py

${DOMAIN_HOME}/bin/startWebLogic.sh $*
