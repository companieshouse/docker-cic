FROM 169942020521.dkr.ecr.eu-west-2.amazonaws.com/ch-serverjre as builder

RUN mkdir -p apache/CICWEB

COPY cic-*.zip apache

RUN cd apache && \
    unzip *.zip && \
    jar xvf cic-ear-*.ear cic-web.war  && \
    mv cic-web.war CICWEB && \
    cd CICWEB  && \
    jar xvf cic-web.war --directory CICWEB js/ images/ html/ css/ 

FROM 169942020521.dkr.ecr.eu-west-2.amazonaws.com/ch-apache

# Add section of Apache config for the CIC app
COPY cic-http.conf conf
COPY index.html apache/CICWEB 

# Include the new config in the main config file
RUN echo "Include conf/cic-http.conf" >> conf/httpd.conf

# Copy over static content from the builder image
COPY --from=builder apache htdocs
