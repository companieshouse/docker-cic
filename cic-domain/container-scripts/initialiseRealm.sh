#!/bin/bash

LDIF_TEMPLATE=${DOMAIN_HOME}/security/DefaultAuthenticatorInit.ldift

# Remove blank line at the end of the template
sed -i '$ d' ${LDIF_TEMPLATE}

# Add group membership to the last user in file which is the weblogic user, and then add the groups
echo "wlsMemberOf: cn=cic_examiner,ou=groups,ou=@realm@,dc=@domain@
wlsMemberOf: cn=cic_administrator,ou=groups,ou=@realm@,dc=@domain@

dn: cn=cic_administrator,ou=groups,ou=@realm@,dc=@domain@
memberURL: ldap:///ou=groups,ou=@realm@,dc=@domain@??sub?(&(objectclass=person)(wlsMemberOf=cn=cic_administrator,ou=groups,ou=@realm@,dc=@domain@))
description: Administrator within CIC App
objectclass: top
objectclass: groupOfUniqueNames
objectclass: groupOfURLs
cn: cic_administrator

dn: cn=cic_examiner,ou=groups,ou=@realm@,dc=@domain@
memberURL: ldap:///ou=groups,ou=@realm@,dc=@domain@??sub?(&(objectclass=person)(wlsMemberOf=cn=cic_examiner,ou=groups,ou=@realm@,dc=@domain@))
description: Examiner within CIC App
objectclass: top
objectclass: groupOfUniqueNames
objectclass: groupOfURLs
cn: cic_examiner" >> ${LDIF_TEMPLATE}

