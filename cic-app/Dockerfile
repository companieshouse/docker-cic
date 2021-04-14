FROM 169942020521.dkr.ecr.eu-west-2.amazonaws.com/cic-domain

# Copy over the CIC application configuration file
COPY --chown=weblogic:weblogic config.properties ${DOMAIN_NAME}

# Copy over utility scripts
COPY --chown=weblogic:weblogic container-scripts container-scripts/

# Set permissions on utility scripts and create upload folder to receive the cic ear file 
RUN chmod 754 container-scripts/*.sh && \
    mkdir -p ${DOMAIN_NAME}/upload

COPY --chown=weblogic:weblogic cic-*.zip ${DOMAIN_NAME}/upload/cic-ear.zip

RUN cd ${DOMAIN_NAME}/upload && \
    unzip cic-ear.zip && \
    mv cic-ear*.ear CIC.ear

CMD ["bash"]
