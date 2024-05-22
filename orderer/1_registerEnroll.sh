#!/usr/bin/env bash
export PATH=${PWD}/../bin:$PATH
export VERBOSE=false
setupOrderCA(){
    mkdir -p organizations/ordererOrganizations
    echo "setting order CA"
    echo 
    docker-compose -f ca-orderer.yaml up -d
    sleep 10
    mkdir -p organizations/ordererOrganizations/example.com

    export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

}

enrollCAAdmin(){
    echo
    echo "Enroll the CA admin"
    echo
    fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
}

nodeOU(){
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml
}

registerOrderersAndAdmin(){
  echo "Registering orderer"
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  sleep 2

  echo "Registering orderer2"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer  --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # -u https://admin:adminpw@localhost:9054 
  sleep 2

  echo "Registering orderer3"
  set -x
  fabric-ca-client register -u https://admin:adminpw@localhost:9054  --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  sleep 2

  echo 
  echo "Registering the orderer admin"
  echo
  fabric-ca-client register -u https://admin:adminpw@localhost:9054  --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
   
}

setupOrderCA
sleep 5
enrollCAAdmin
sleep 2
nodeOU
sleep 2
registerOrderersAndAdmin