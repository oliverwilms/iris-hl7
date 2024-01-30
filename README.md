 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/iris-hl7)
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-hl7&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-hl7)
 [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-hl7&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-hl7)

# iris-hl7

## Description
iris-hl7 transforms HL7 messages to JSON

You can find [Online Demo](https://iris-hl7.demo.community.intersystems.com/csp/user/EnsPortal.ProductionConfig.zen?PRODUCTION=otw.NewProduction&$NAMESPACE=USER) here.

![screenshot](https://github.com/oliverwilms/bilder/blob/main/iris-hl7.JPG)

If your Productions is not running, click the Start button.

HL7FileService is configured to process any file from /usr/irissys/mgr/hl7/ directory. Message Schema Category is set for HL7 2.3. HL7 messages are sent to BPL HL7 to JSON.

Visual Trace below shows the HL7 message included in the repo and the conversion to JSON.
The people who have been asked to persist HL7 messages expressed that it is easier for them to parse JSON rather than the delimited HL7.
They provided a schema how they want to receive the HL7 messages converted into JSON.

I did not want to create separate DTLs to transform individual HL7 message formats, but I created code that will transform any HL7 message into the desired JSON format.

![screenshot](https://github.com/oliverwilms/bilder/blob/main/iris-hl7_trace_hl7.JPG)

![screenshot](https://github.com/oliverwilms/bilder/blob/main/iris-hl7_trace_json.JPG)

## Test it out

Please add Operation to your Production like this:
![screenshot](https://github.com/oliverwilms/bilder/blob/main/HL7demo_HTTP_Operation.PNG)
Send a 2.3 HL7 message and check the Message Viewer in [Online Demo](https://iris-hl7.demo.community.intersystems.com/csp/user/EnsPortal.MessageViewer.zen) here.

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 

### IPM

Open IRIS for Health installation with IPM client installed. Call in any namespace:

```
USER>zpm "install iris-hl7"
```

### Docker (e.g. for dev purposes)

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/oliverwilms/iris-hl7.git
```

Open the terminal in this directory and run:

```
$ docker-compose up -d
```
