#!/bin/bash
cp ../orderer/channel-artifacts/mychannel2.tx .
# cp -r ../orderer/organizations/ordererOrganizations ./organizations
sleep 1
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config
export VERBOSE=false
export CORE_PEER_TLS_ENABLED=true
export CHANNEL_NAME='mychannel2'


export ORDERER_CA=${PWD}/../orderer/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
# export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt


getGlobalPeer0Org2(){
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
}

getGlobalPeer1Org2(){
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_ADDRESS=localhost:10051
}


fetchChannelBlock() {
    export FABRIC_CFG_PATH=${PWD}/../config
    getGlobalPeer0Org2
    peer channel fetch 0 $CHANNEL_NAME.block -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
}

# joinChannel ORG
joinChannel() {
    
    export FABRIC_CFG_PATH=${PWD}/../config
    getGlobalPeer0Org2
    peer channel join -b ./$CHANNEL_NAME.block
    sleep 2
    getGlobalPeer1Org2
    peer channel join -b ./$CHANNEL_NAME.block
}

setAnchorPeer() {
  export FABRIC_CFG_PATH=${PWD}/../config
  getGlobalPeer0Org1
  peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}






echo "featching channel ${CHANNEL_NAME} block"
fetchChannelBlock
sleep 2
## Join all the peers to the channel
echo "Joining org1 peer to the channel..."
joinChannel

# sleep 2
# ## Set the anchor peers for each org in the channel
# echo "Setting anchor peer for org1..."
# setAnchorPeer 

# echo "Channel '$CHANNEL_NAME' joined"
