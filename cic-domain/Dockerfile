FROM ch-weblogic

# IMPORTANT - the default admin password should be supplied as a build arg
# e.g. --build-arg ADMIN_PASSWORD=notsecure123.  This password will be visible in the image
# so MUST later be reset to a secure value when starting the admin container.
ARG ADMIN_PASSWORD

ENV ORACLE_HOME=/apps/oracle \
    DOMAIN_NAME=cicdomain \
    ADMIN_NAME=wladmin

WORKDIR $ORACLE_HOME

# Copy over utility scripts for creating the domain, setting security and starting servers
COPY --chown=weblogic:weblogic container-scripts container-scripts/

# Initialise the domain using a standard template provided with WebLogic
RUN $ORACLE_HOME/oracle_common/common/bin/wlst.sh -skipWLSModuleScanning container-scripts/create-domain.py 

# Copy across a custom config.xml and cic-jdbc.xml
COPY --chown=weblogic:weblogic config ${DOMAIN_NAME}/config/

# Set the credentials in the custom config.xml
RUN $ORACLE_HOME/oracle_common/common/bin/wlst.sh -skipWLSModuleScanning container-scripts/set-credentials.py && \
    chmod 754 container-scripts/*.sh

CMD ["bash"]
