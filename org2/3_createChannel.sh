#!/bin/bash
cp ../orderer/channel-artifacts/mychannel.tx .
cp -r ../orderer/organizations/ordererOrganizations ./organizations
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config
export VERBOSE=false
export CORE_PEER_TLS_ENABLED=true
export CHANNEL_NAME='mychannel'


export ORDERER_CA=${PWD}/../orderer/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
# export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt


# if already been created by other org no need to create again 
# createChannelTx() {
# 	set -x
# 	configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
# 	res=$?
# 	{ set +x; } 2>/dev/null
#   verifyResult $res "Failed to generate channel configuration transaction..."
# }

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

# if already been created by other org no need to create again 
createChannel() {
  export FABRIC_CFG_PATH=${PWD}/configtx
	getGlobalPeer0Org2

	peer channel create -o localhost:7050 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer.example.com -f ./${CHANNEL_NAME}.tx --outputBlock ./${CHANNEL_NAME}.block --tls --cafile $ORDERER_CA
}

fetchChannelBlock() {
  getGlobalPeer0Org2
  peer channel fetch 0 $CHANNEL_NAME.block -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
}

# joinChannel ORG
joinChannel() {
  getGlobalPeer0Org2
  peer channel join -b ./$CHANNEL_NAME.block

  getGlobalPeer1Org2
  peer channel join -b ./$CHANNEL_NAME.block
}

setAnchorPeer() {
  getGlobalPeer0Org2
  peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}


# FABRIC_CFG_PATH=${PWD}/configtx

# ## Create channeltx
# infoln "Generating channel create transaction '${CHANNEL_NAME}.tx'"
# createChannelTx


## Create channel

# echo "Creating channel ${CHANNEL_NAME}"
# createChannel
# echo "Channel '$CHANNEL_NAME' created"
# sleep 2

echo "fetching the channel config block 0"
fetchChannelBlock

sleep 2
## Join all the peers to the channel
echo "Joining org1 peer to the channel..."
joinChannel
sleep 2

## Set the anchor peers for each org in the channel
echo "Setting anchor peer for org1..."
setAnchorPeer
sleep 2

echo "Channel '$CHANNEL_NAME' joined"
