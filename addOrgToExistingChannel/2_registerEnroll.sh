#!/usr/bin/env bash
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx
export VERBOSE=false
cp -r ../orderer/organizations/ordererOrganizations ./organizations
mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com
# creating peer0 MSP
createMSPPeer0(){
    echo
    echo "Generating the peer0 msp"
    echo
    fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp --csr.hosts peer0.org4.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
    sleep 2
    cp ${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp/config.yaml
    echo
    echo "Generating the peer0-tls certificates"
    echo

    fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls --enrollment.profile tls --csr.hosts peer0.org4.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
    sleep 2
    cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt
    cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/server.crt
    cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/server.key

    mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts
    cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts/ca.crt

    mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/tlsca
    cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/tlsca/tlsca.org4.example.com-cert.pem

    mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/ca
    cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/ca/ca.org4.example.com-cert.pem    

}
# creating peer1 MSP
createMSPPeer1(){
    echo
    echo "Generating the peer1 msp"
    echo
    fabric-ca-client enroll -u https://peer1:peer1pw@localhost:11054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/msp --csr.hosts peer1.org4.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
    sleep 2
    cp ${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/msp/config.yaml
    echo
    echo "Generating the peer1-tls certificates"
    echo

    fabric-ca-client enroll -u https://peer1:peer1pw@localhost:11054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls --enrollment.profile tls --csr.hosts peer1.org4.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
    sleep 2
    cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/ca.crt
    cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/server.crt
    cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/server.key

    mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts
    cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts/ca.crt

    mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/tlsca
    cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/tlsca/tlsca.org4.example.com-cert.pem

    mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/ca
    cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/ca/ca.org4.example.com-cert.pem    

}

# creating User MSP
createUserMSP(){
   echo
   echo "Generating the user msp"
   echo
   fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/users/User1@org4.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
   sleep 2
   cp ${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org4.example.com/users/User1@org4.example.com/msp/config.yaml
}

# creting Admin MSP

createAdminMSP(){
    echo
    echo "Generating the org admin msp"
    echo
    fabric-ca-client enroll -u https://org4admin:org4adminpw@localhost:11054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
    sleep 2
    cp ${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp/config.yaml
}

createMSPPeer0
sleep 2
createMSPPeer1
sleep 2
createUserMSP
sleep 2
createAdminMSP
sleep 5

docker-compose -f docker-compose-peer.yaml up -d

sleep 10

docker ps -a