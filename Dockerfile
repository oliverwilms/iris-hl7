ARG IMAGE=containers.intersystems.com/intersystems/irishealth-community:2022.1.0.209.0
FROM $IMAGE

USER root

# create directories for testing environment
RUN mkdir -p /opt/hl7xml/app /opt/hl7xml/db

# copy source code
WORKDIR /opt/hl7xml
COPY . app

# change ownership
RUN chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/hl7xml
USER ${ISC_PACKAGE_MGRUSER}

# run iris.script
WORKDIR /opt/hl7xml/app
RUN iris start IRIS \
    && iris session IRIS < iris.script \
    && iris stop IRIS quietly
