
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config
export VERBOSE=false
export CORE_PEER_TLS_ENABLED=true
export CHANNEL_NAME="mychannel"
cp ../org1/config_block.pb .


export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
# export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt


getGlobalPeer0org3(){
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
}

getGlobalPeer1org3(){
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
    export CORE_PEER_ADDRESS=localhost:12051
}

generateOrg3Config(){
        configtxgen -printOrg Org3MSP > org3.json
}

fetchChannelConfig(){
    getGlobalPeer0org3
    echo 
    echo "fetching latest config block"
    echo    
    peer channel fetch 0 ${CHANNEL_NAME}.block -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME --tls --cafile $ORDERER_CA

}

joinChannel(){
        getGlobalPeer0org3
        echo
        echo "joining channel ${CHANNEL_NAME}"
        echo
        peer channel join -b ${CHANNEL_NAME}.block
}

joinChannelPeer1(){
        getGlobalPeer1org3
        echo
        echo "joining channel ${CHANNEL_NAME}"
        echo
        peer channel join -b ${CHANNEL_NAME}.block
}

# join org to existing channel
export FABRIC_CFG_PATH=${PWD}/configtx
# generateOrg3Config
sleep 2
export FABRIC_CFG_PATH=${PWD}/../config

# sleep 2
# fetchChannelConfig
# sleep 2
# joinChannel

sleep 2
joinChannelPeer1


