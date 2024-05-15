#!/usr/bin/env bash

removeOrg1CA(){
    echo "remove Org1 CA"
    docker-compose -f ./org1/docker-compose-ca.yaml down -v
}

# removeOrg1CA
rm -rf ./org1/organizations