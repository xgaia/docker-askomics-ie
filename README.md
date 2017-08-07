# Docker AskOmics + Virtuoso (For Galaxy Interactive Environment)

![Docker Build](https://img.shields.io/docker/pulls/xgaia/askomics-ie.svg)
[![Build Status](https://travis-ci.org/xgaia/docker-askomics-virtuoso-ie.svg?branch=master)](https://travis-ci.org/xgaia/docker-askomics-virtuoso-ie)

AskOmics and Virtuoso dockerized

## Pull from dockerHub

    docker pull xgaia/askomics-ie

## Or build

    # Clone the repo
    git clone https://github.com/xgaia/docker-askomics-virtuoso-ie.git
    cd docker-askomics-virtuoso-ie
    docker build -t askomics-ie .

## Run

    docker run --name myAskOmics \
        -p 6543:6543 \
        d xgaia/askomics-ie


This image is for the Galaxy Interactive Environment. To use AskOmics alone, please use [this image](https://github.com/askomics/docker-askomics) or [this docker compose](https://github.com/askomics/askomics-docker-compose).
