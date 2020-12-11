FROM ch-oraclelinux as builder

ARG CIC_APACHE_URL=http://release.ch.gov.uk/chips/cics/cic-apache.tar.gz

# Download the CIC apache static content file and extract into a builder image
# This is required as the ch-apache image does not have curl or tar available
RUN mkdir apache && \
    curl ${CIC_APACHE_URL} -o apache.tar.gz && \
    cd apache && \
    tar -xzf ../apache.tar.gz

FROM ch-apache

# Add section of Apache config for the CIC app
COPY cic-http.conf conf

# Include the new config in the main config file
RUN echo "Include conf/cic-http.conf" >> conf/httpd.conf

# Copy over static content from the builder image
COPY --from=builder apache htdocs
