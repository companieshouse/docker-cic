FROM cic-domain

ARG RELEASE_ARTIFACT=cic-ear-1.0.zip
ARG CIC_ZIP_URL=http://release.ch.gov.uk/chips/cics/${RELEASE_ARTIFACT}

# Copy over the CIC application configuration file
COPY --chown=weblogic:weblogic config.properties ${DOMAIN_NAME}

# Copy over utility scripts
COPY --chown=weblogic:weblogic container-scripts container-scripts/

# Download the CIC ZIP file into the ${DOMAIN_NAME}/upload directory on the image
RUN chmod 754 container-scripts/*.sh && \
    mkdir -p ${DOMAIN_NAME}/upload && \
    curl ${CIC_ZIP_URL} -o ${DOMAIN_NAME}/upload/${RELEASE_ARTIFACT}  && \
    cd ${DOMAIN_NAME}/upload && \
    unzip ${RELEASE_ARTIFACT} 

COPY --chown=weblogic:weblogic cic-ear-1.0.ear ${DOMAIN_NAME}/upload/CIC.ear

CMD ["bash"]
