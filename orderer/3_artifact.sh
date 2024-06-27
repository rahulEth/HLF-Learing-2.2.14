#!/usr/bin/env bash
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx
export VERBOSE=false

# System channel
SYS_CHANNEL="system-channel"

# channel name defaults to "mychannel"
CHANNEL_NAME="mychannel"

echo $CHANNEL_NAME

echo "Generating Orderer Genesis block"

configtxgen -profile TwoOrgsOrdererGenesis -channelID $SYS_CHANNEL -outputBlock ./genesis.block
sleep 2


# echo "Generate channel configration"

# configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME

# sleep 2
# echo "#######    Generating anchor peer update for Org1MSP  ##########"
# configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ../org1/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP

# sleep 2
# echo "#######    Generating anchor peer update for Org2MSP  ##########"
# configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ../org2/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP

# sleep 2
# docker-compose -f docker-compose-orderer.yaml up -d
# sleep 10
# docker ps -a    



