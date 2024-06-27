
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config
export VERBOSE=false
export CORE_PEER_TLS_ENABLED=true
export CHANNEL_NAME="mychannel"


export ORDERER_CA=${PWD}/../orderer/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG4_CA=${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt
# export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt


getGlobalPeer0org4(){
    export CORE_PEER_LOCALMSPID="Org4MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG4_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp
    export CORE_PEER_ADDRESS=localhost:13051
}

getGlobalPeer1org4(){
    export CORE_PEER_LOCALMSPID="Org4MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG4_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp
    export CORE_PEER_ADDRESS=localhost:14051
}

generateOrg4Config(){
    echo
    echo "generating org4.json"
    echo
    configtxgen -printOrg Org4MSP > org4.json
}

fetchChannelConfig(){
    getGlobalPeer0org4
    echo 
    echo "fetching latest config block"
    echo    
    peer channel fetch 0 ${CHANNEL_NAME}.block -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME --tls --cafile $ORDERER_CA

}

joinChannel(){
        getGlobalPeer0org4
        echo
        echo "joining channel ${CHANNEL_NAME}"
        echo
        peer channel join -b ${CHANNEL_NAME}.block
}

joinChannelPeer1(){
        getGlobalPeer1org4
        echo
        echo "joining channel ${CHANNEL_NAME}"
        echo
        peer channel join -b ${CHANNEL_NAME}.block
}

generateOrg4Config

sleep 2
fetchChannelConfig

sleep 2
joinChannel

sleep 2
joinChannelPeer1


