cp -r ../organizations/ordererOrganizations ./peerOrganizations
sleep 1
export PATH=${PWD}/../../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../../config
export VERBOSE=false
export CORE_PEER_TLS_ENABLED=true
export CHANNEL_NAME='mychannel'


export ORDERER_CA=${PWD}/peerOrganizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER2_ORG1_CA=${PWD}/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/ca.crt
# export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt


getGlobalPeer2Org1(){
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER2_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:6051
}

fetchChannelBlock(){
    export FABRIC_CFG_PATH=${PWD}/../../config
    getGlobalPeer2Org1
    peer channel fetch 0 $CHANNEL_NAME.block -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
}

# joinChannel ORG
joinChannel(){
    
    export FABRIC_CFG_PATH=${PWD}/../../config
    getGlobalPeer2Org1
    peer channel join -b ./$CHANNEL_NAME.block
}


# fetchChannelBlock
# sleep 5

# joinChannel