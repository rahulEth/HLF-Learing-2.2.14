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
    echo "remove AddOrgConsortium CA"
    docker-compose -f ./addOrgConsortium/docker-compose-ca.yaml down -v
}

removeAddOrgToExistingChannelCA(){
    echo "remove AddOrgToExistingChannel CA"
    docker-compose -f ./addOrgToExistingChannel/docker-compose-ca.yaml down -v
}


removeOrderers() {
  echo "Removing orderers "
  docker-compose -f ./orderer/docker-compose-orderer.yaml down -v
}

removeOrg1() {

  echo "Removing Org1 Peers"
  docker-compose -f ./org1/docker-compose-peer.yaml down -v
    docker-compose -f ./org1/addPeer/newPeer.yaml down -v
}

removeOrg2() {
  echo "Removing Org2 Peers"
  docker-compose -f ./org2/docker-compose-peer.yaml down -v
}

removeAddOrgToExistingChannel() {

  echo "Removing AddOrgToExistingChannel Peers"
  docker-compose -f ./addOrgToExistingChannel/docker-compose-peer.yaml down -v
}

removeAddOrgConsortium() {
  echo "Removing AddOrgConsortium Peers"
  docker-compose -f ./addOrgConsortium/docker-compose-peer.yaml down -v
}


removeExplorer() {
  echo "Removing explorer"
  docker-compose -f ./explorer-setup/docker-compose-explorer.yaml down -v
}

removeGrafanaPrometheus() {
  echo "Removing Grafana and Prometheus"
  docker-compose -f monitoring/docker-compose-monitor.yaml down -v
}



removeOrg1CA
removeOrg2CA
removeAddOrgConsortiumCA
removeAddOrgToExistingChannelCA
removeOrderers
removeOrg1
removeOrg2
removeAddOrgToExistingChannel
removeAddOrgConsortium
removeExplorer
removeGrafanaPrometheus

rm -rf ./org1/organizations
rm -rf ./org1/addPeer/peerOrganizations
rm -rf ./org2/organizations
rm -rf ./addOrgConsortium/organizations
rm -rf ./addOrgToExistingChannel/organizations

