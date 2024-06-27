
export CORE_PEER_TLS_ENABLED=true
export PEER2_ORG1_CA=${PWD}/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/ca.crt
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

setGlobalsForPeer2Org1() {
  export CORE_PEER_LOCALMSPID="Org1MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG1_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
  export CORE_PEER_ADDRESS=localhost:6051
}

installChaincodePeer2Org1(){
  chaincodeInfo
  setGlobalsForPeer1Org1
  peer lifecycle chaincode install ${CC_NAME}.tar.gz
  echo
  echo "chaincode installed on peer1.org1.example.com"
  echo
}


insertTransaction(){
    chaincodeInfo
    echo "channel name ${CHANNEL_NAME}"
    setGlobalsForPeer1Org2

    echo "CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED}"
    echo "ORDERER_CA=${ORDERER_CA}"
    echo "CC_NAME=${CC_NAME}"
    echo "PEER1_ORG1_CA=${PEER1_ORG1_CA}"
    # peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls ${CORE_PEER_TLS_ENABLED} --cafile ${ORDERER_CA} -C ${CHANNEL_NAME} -n ${CC_NAME} --peerAddresses localhost:1051 --tlsRootCertFiles ${PEER1_ORG2_CA} -c '{"function": "createCar", "Args":["CAR103","AudiX","R8","Black", "CM"]}'

    peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C ${CHANNEL_NAME} -n ${CC_NAME} --peerAddresses localhost:8051 --tlsRootCertFiles $PEER1_ORG1_CA -c '{"function": "createCar", "Args":["CAR103","AudiX","R8","Black", "CM"]}'

}

readTransaction(){
    chaincodeInfo
    echo "channel name ${CHANNEL_NAME}"
    setGlobalsForPeer1Org2
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} --peerAddresses localhost:8051 --tlsRootCertFiles $PEER1_ORG1_CA  -c '{"function": "queryCar", "Args": ["CAR103"]}'
}


installChaincodePeer1Org1