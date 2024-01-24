# hl7

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 

### IPM

Open IRIS for Health installation with IPM client installed. Call in any namespace:

```
USER>zpm "install hl7"
```

### Docker (e.g. for dev purposes)

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/oliverwilms/hl7.git
```

Open the terminal in this directory and run:

```
$ docker-compose up -d
```
