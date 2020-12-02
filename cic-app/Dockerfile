FROM cic-domain

ARG CIC_EAR_URL=http://release.ch.gov.uk/chips/cics/CIC.ear

# Copy over the CIC application configuration file
COPY --chown=weblogic:weblogic config.properties ${DOMAIN_NAME}

# Copy over utility scripts
COPY --chown=weblogic:weblogic container-scripts container-scripts/

# Download the CIC EAR file into the ${DOMAIN_NAME}/upload directory on the image
RUN mkdir -p ${DOMAIN_NAME}/upload && \
    curl ${CIC_EAR_URL} -o ${DOMAIN_NAME}/upload/CIC.ear && \
    chmod 754 container-scripts/*.sh

CMD ["bash"]
