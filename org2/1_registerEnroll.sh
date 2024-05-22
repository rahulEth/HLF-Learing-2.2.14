#!/usr/bin/env bash
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../configtx
export VERBOSE=false
setupOrg2CA(){
    echo "setup org2 CA"
    mkdir -p organizations
    docker-compose -f docker-compose-ca.yaml up -d

    sleep 10
    echo "Enrolling the CA admin"
    mkdir -p organizations/peerOrganizations/org2.example.com/

    export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.example.com/

    fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-org2 --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
}

nodeOU(){
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml
}


registerPeersAdminUsers(){
  echo
  echo "Registering peer0"
  echo
  fabric-ca-client register --caname ca-org2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  sleep 2

  echo
  echo "Registering peer1"
  echo
  fabric-ca-client register --caname ca-org2 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  sleep 2

  echo
  echo "Registering user"
  echo
  fabric-ca-client register --caname ca-org2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  sleep 2

  echo
  echo "Registering the org admin"
  echo
  fabric-ca-client register --caname ca-org2 --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
}


setupOrg2CA
sleep 5
nodeOU
sleep 2
registerPeersAdminUsers
