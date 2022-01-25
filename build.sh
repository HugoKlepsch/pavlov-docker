#!/bin/bash

SERVERNAME="Sugma Ligma PUSH 24/7"
APIKEY=`cat APIKEY`
VERSION=`cat VERSION`

sed -e "s#{{APIKEY}}#${APIKEY}#g" -e "s#{{SERVERNAME}}#${SERVERNAME}#g" Game.template.ini > Game.ini

sudo docker build . --tag pavlov-server:${VERSION}