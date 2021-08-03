#!/bin/bash

#purpose of this script is to add any secrets that need to exist for initial install of components
# if using an external secret manager this could be used for one time config

ytt -v vrlic_api_token=$VRLIC_TOKEN -v $DOCKER_PASS -v $DOCKER_USER -f manifests/secrets.yml | kubectl apply -f -