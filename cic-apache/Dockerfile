FROM ch-serverjre as builder

ARG RELEASE_ARTIFACT=cic-ear-1.0.zip
ARG CIC_ZIP_URL=http://release.ch.gov.uk/chips/cics/${RELEASE_ARTIFACT}
 
# Download the CIC apache static content file and extract into a builder image
# This is required as the ch-apache image does not have curl or tar available
RUN mkdir -p apache/CICWEB && \
    curl ${CIC_ZIP_URL} -o apache/${RELEASE_ARTIFACT}  && \
    cd apache && \
    unzip ${RELEASE_ARTIFACT} && \
    jar xvf cic-ear-1.0.ear cic-web.war  && \
    mv cic-web.war CICWEB && \
    cd CICWEB  && \
    jar xvf cic-web.war --directory CICWEB js/ images/ html/ css/ 

FROM ch-apache

# Add section of Apache config for the CIC app
COPY cic-http.conf conf
COPY index.html apache/CICWEB 

# Include the new config in the main config file
RUN echo "Include conf/cic-http.conf" >> conf/httpd.conf

# Copy over static content from the builder image
COPY --from=builder apache htdocs
