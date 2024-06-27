
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config
export VERBOSE=false
export CORE_PEER_TLS_ENABLED=true
export CHANNEL_NAME='mychannel'


export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG4_CA=${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt
# export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt

chaincodeInfo() {
  export CHANNEL_NAME="mychannel"
  export CC_RUNTIME_LANGUAGE="golang"
  export CC_VERSION="1.0"
  export CC_SRC_PATH=${PWD}/../chaincodes/fabcar/go
  export CC_NAME="fabcargo"
  export CC_SEQUENCE=1

}
setGlobalPeer0Org4(){
    export CORE_PEER_LOCALMSPID="Org4MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG4_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp
    export CORE_PEER_ADDRESS=localhost:13051
}

setGlobalPeer1Org4(){
    export CORE_PEER_LOCALMSPID="Org4MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG4_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp
    export CORE_PEER_ADDRESS=localhost:14051
}

packageChaincode() {
   setGlobalPeer0Org4
   chaincodeInfo
   rm -rf ${CC_NAME}.tar.gz

   peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION}

   echo 
   echo "chaincode packaged successfully...."
   echo

}

installChaincodePeer0Org4(){
  chaincodeInfo
  setGlobalPeer0Org4
  peer lifecycle chaincode install ${CC_NAME}.tar.gz
  echo
  echo "chaincode installed on peer0.org1.example.com"
  echo
}

installChaincodePeer1Org4(){
  chaincodeInfo
  setGlobalPeer1Org4
  peer lifecycle chaincode install ${CC_NAME}.tar.gz
  echo
  echo "chaincode installed on peer1.org1.example.com"
  echo
}

queryInstalled() {
  echo
  echo "getting package Id"
  echo  
  setGlobalPeer0Org4
  peer lifecycle chaincode queryinstalled >&log.txt

  cat log.txt

#   PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

#   echo PackageID is ${PACKAGE_ID}
}

queryInstalledPeer1() {
  echo
  echo "getting package Id"
  echo  
  setGlobalPeer0Org4
  peer lifecycle chaincode queryinstalled >&logPeer1.txt

  cat logPeer1.txt

#   PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

#   echo PackageID is ${PACKAGE_ID}
}
approveChaincode(){
    chaincodeInfo
    setGlobalPeer0Org4
    echo 
    echo "approval of chaincode"
    echo
    echo "sequence no ${CC_SEQUENCE}"
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

    echo PackageID is ${PACKAGE_ID}
    peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID}  --sequence ${CC_SEQUENCE} --init-required
}

queryCommitted(){
    chaincodeInfo
    setGlobalPeer0Org4
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name $CC_NAME
}


insertTransaction() { 
    chaincodeInfo 
    setGlobalPeer0Org4
    peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_ORG4_CA -c '{"function": "createCar", "Args":["CAR104","Tesla","X","White", "CM"]}'
    sleep 2
}

readTransaction() {
    chaincodeInfo 
    setGlobalPeer0Org4
    echo
    echo "Reading a transaction"
    echo

    # Query Car by Id
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryCar","Args":["CAR104"]}'
}

readTransactionPeer1() {
    chaincodeInfo 
    setGlobalPeer1Org4
    echo
    echo "Reading a transaction"
    echo

    # Query Car by Id
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryCar","Args":["CAR104"]}'
}

# packaging chaincode
# packageChaincode
# sleep 2

# query installed chaincodes
# queryInstalled
# sleep 2

# approve chaincode by org4
# approveChaincode
# sleep 2

# check if the chaincode definition you have approved has already been committed to the channel.
# queryCommitted
# sleep 2

# install chaincode peer1.org4.example.com
# installChaincodePeer0Org4
# sleep 2


# install chaincode peer1.org4.example.com
# installChaincodePeer1Org4
# sleep 2

# queryInstalledPeer1
# sleep 2

insertTransaction
# sleep 2


# readTransactionPeer1


