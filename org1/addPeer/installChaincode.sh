#!/bin/bash

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/peerOrganizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER2_ORG1_CA=${PWD}/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../config
export PATH=${PWD}/../../bin:$PATH

chaincodeInfo() {
  export CHANNEL_NAME="mychannel"
  export CC_RUNTIME_LANGUAGE="golang"
  export CC_VERSION="1.0"
  export CC_SRC_PATH=${PWD}/../../chaincodes/fabcar/go
  export CC_NAME="fabcargo"
  export CC_SEQUENCE=1

}
setGlobalsForPeer2Org1() {
  export CORE_PEER_LOCALMSPID="Org1MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER2_ORG1_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
  export CORE_PEER_ADDRESS=localhost:6051
}


packageChaincode() {
   chaincodeInfo
   rm -rf ${CC_NAME}.tar.gz

   peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION}

   echo 
   echo "chaincode packaged successfully...."
   echo

}

installChaincode() {
    setGlobalsForPeer2Org1
    chaincodeInfo
    peer lifecycle chaincode install ${CC_NAME}.tar.gz

    echo 
    echo "chaincode installed on peer2 org1 successfully...."
    echo
}

queryInstalled() {
  echo
  echo "getting package Id"
  echo  
  setGlobalsForPeer2Org1
  peer lifecycle chaincode queryinstalled >&log.txt

  cat log.txt

  PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

  echo PackageID is ${PACKAGE_ID}
}
approveForMyOrg1() {

  setGlobalsForPeer2Org1
  chaincodeInfo
  echo 
  echo "approval of chaincode"
  echo
  echo "sequence no ${CC_SEQUENCE}"
  peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID}  --sequence ${CC_SEQUENCE} --init-required
}

insertTransaction() {
  setGlobalsForPeer2Org1
  chaincodeInfo
  peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} --peerAddresses localhost:6051 --tlsRootCertFiles $PEER2_ORG1_CA -c '{"function": "createCar", "Args":["CAR105","Tesla","X1","White", "CM"]}'

  sleep 2
}
readTransaction() {
  echo "Reading a transaction"
  setGlobalsForPeer2Org1
  chaincodeInfo
  # Query Car by Id
  peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryCar","Args":["CAR105"]}'
}

# packageChaincode

# installChaincode
# sleep 2
queryInstalled
# sleep 2
# approveForMyOrg1
# sleep 2
# insertTransaction
# sleep 2
# readTransaction



