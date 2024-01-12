ARG IMAGE=containers.intersystems.com/intersystems/irishealth-community:2022.1.0.209.0
FROM $IMAGE

USER root

# create directories for testing environment
RUN mkdir -p /opt/hl7xml/app /opt/hl7xml/db
