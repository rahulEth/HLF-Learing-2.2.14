#!/usr/bin/env bash
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx
export VERBOSE=false

mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer.example.com
ordererMSP(){
    # chmod +x ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com
    echo "1"
    echo "Generating the orderer msp"
    echo
    fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    sleep 2 
    cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

    echo "Generating the orderer-tls certificates"

    fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    sleep 2

    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt

    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt

    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

    mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts

    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

    mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts

    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

}

mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer2.example.com


orderer2MSP(){
    mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer2.example.com
    echo
    echo "Generating the orderer2 msp"
    echo
    fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    
    sleep 2
    cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/config.yaml

    echo "Generating the orderer-tls certificates"

    fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls --enrollment.profile tls --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    sleep 2
    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.crt
    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.key

    mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts
    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

    mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

}

mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer3.example.com

orderer3MSP(){
    mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer3.example.com
    echo
    echo "Generating the orderer msp"
    echo
    fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    sleep 2
    cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/config.yaml

    echo "Generating the orderer-tls certificates"

    fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls --enrollment.profile tls --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    sleep 2
    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/ca.crt
    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.crt
    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.key

    mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts
    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

    mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

}


adminMSP(){
    echo "Generating the admin msp"
    fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml
}


ordererMSP
sleep 2
orderer2MSP
sleep 2
orderer3MSP
sleep 2
adminMSP
sleep 2
