#!/bin/bash

DOMAIN_HOME="${ORACLE_HOME}/${DOMAIN_NAME}"

# Update the CIC app config.properties to set the password for ldap access
sed -i "s/@cic-admin-ldap-password@/${LDAP_CREDENTIAL}/g" ${DOMAIN_HOME}/config.properties


${ORACLE_HOME}/container-scripts/startNodeManager.sh

