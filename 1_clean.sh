#!/usr/bin/env bash

removeOrg1CA(){
    echo "remove Org1 CA"
    docker-compose -f ./org1/docker-compose-ca.yaml down -v
}

removeOrg2CA(){
    echo "remove Org2 CA"
    docker-compose -f ./org2/docker-compose-ca.yaml down -v
}


removeAddOrgConsortiumCA(){
    echo "remove Org2 CA"
    docker-compose -f ./addOrgConsortium/docker-compose-ca.yaml down -v
}






# removeOrg1CA
rm -rf ./org1/organizations
rm -rf ./org2/organizations
rm -rf ./org2/organizations
rm -rf ./addOrgConsortium/organizations
