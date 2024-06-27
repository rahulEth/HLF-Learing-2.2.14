#!/bin/bash

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER1_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../config
export PATH=${PWD}/../bin:$PATH

chaincodeInfo() {
  export CHANNEL_NAME="mychannel"
  export CC_RUNTIME_LANGUAGE="golang"
  export CC_VERSION="1.0"
  export CC_SRC_PATH=${PWD}/../chaincodes/fabcar/go
  export CC_NAME="fabcargo"
  export CC_SEQUENCE=1

}
preSetupGO() {
  echo Vendoring Go dependencies ...
  pushd ../chaincodes/fabcar/go
  GO111MODULE=on go mod vendor
  popd
  echo Finished vendoring Go dependencies
}

setGlobalsForPeer0Org1() {
  export CORE_PEER_LOCALMSPID="Org1MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
  export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1Org1() {
  export CORE_PEER_LOCALMSPID="Org1MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG1_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
  export CORE_PEER_ADDRESS=localhost:8051
}


packageChaincode() {
   setGlobalsForPeer0Org1

   rm -rf ${CC_NAME}.tar.gz

   peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION}

   echo 
   echo "chaincode packaged successfully...."
   echo

}

installChaincode() {
   setGlobalsForPeer0Org1
   peer lifecycle chaincode install ${CC_NAME}.tar.gz

   echo 
   echo "chaincode installed on peer0 org1 successfully...."
   echo
}

queryInstalled() {
  echo
  echo "getting package Id"
  echo  
  setGlobalsForPeer0Org1
  peer lifecycle chaincode queryinstalled >&log.txt

  cat log.txt

  PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

  echo PackageID is ${PACKAGE_ID}
}
approveForMyOrg1() {

  setGlobalsForPeer0Org1
  chaincodeInfo
  echo 
  echo "approval of chaincode"
  echo
  echo "sequence no ${CC_SEQUENCE}"
  peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID}  --sequence ${CC_SEQUENCE} --init-required
}

getblock() {
  peer channel getinfo -c mychannel -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA
}

checkCommitReadyness() {
  echo
  echo "check chaincode ready committness"
  echo
  chaincodeInfo
  peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} --init-required --output json

}
commitChaincodeDefination() {
  chaincodeInfo
  peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --sequence ${CC_SEQUENCE} --version ${CC_VERSION} --init-required

}

queryCommitted() {

  peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME} --output json

}
chaincodeInvokeInit() {

  peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME -n ${CC_NAME} --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --isInit -c '{"function": "initLedger","Args":[]}'

}

insertTransaction() {

  peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA -c '{"function": "createCar", "Args":["CAR101","Honda","City","White", "CM"]}'

  sleep 2
}
readTransaction() {
  echo "Reading a transaction"

  # Query all cars

  peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["queryAllCars"]}'

  # Query Car by Id
  peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryCar","Args":["CAR101"]}'
}

lifecycleCommands() {
  # packageChaincode
  # sleep 2
  # installChaincode
  # sleep 2
  # queryInstalled
  # sleep 2
  # approveForMyOrg1
  # sleep 2
  # getblock
  # checkCommitReadyness
  # sleep 2
  commitChaincodeDefination
  # sleep 2
  # queryCommitted
  # sleep 2
  # chaincodeInvokeInit
  # sleep 10
}
getInstallChaincodes() {

  peer lifecycle chaincode queryinstalled

}

## vendoring go chaincode 
# preSetupGO

## chaincode name , channel name, version, sequence, lang etc..
# chaincodeInfo

## set ENVS for peer0 org1
# setGlobalsForPeer0Org1
# sleep 2

## packaging , incstaaling, queryinstalled, org1approval, querycommitted,  
# lifecycleCommands

# insertTransaction
# readTransaction
# getInstallChaincodes



# peer1.org1.example.com


