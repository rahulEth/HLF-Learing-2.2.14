
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config
export VERBOSE=false
export CORE_PEER_TLS_ENABLED=true
export CHANNEL_NAME='mychannel'

cp ../addOrgConsortium/org3.json .


export ORDERER_CA=${PWD}/../orderer/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
# export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt


getGlobalPeer0Org1(){
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

fetchConfig(){
   getGlobalPeer0Org1

   peer channel fetch config config_block.pb -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
}



convertToJson(){
    getGlobalPeer0Org1
    configtxlator proto_decode --input config_block.pb --type common.Block --output config_block.json
    jq ".data.data[0].payload.data.config" config_block.json > config.json
}

addOrg3(){
    getGlobalPeer0Org1
    jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"Org3MSP":.[1]}}}}}' config.json org3.json > modified_config.json
    configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb
}

computeDeltas(){
    getGlobalPeer0Org1
    echo
    echo "computing deltas"
    echo 
    configtxlator proto_encode --input config.json --type common.Config --output config.pb
    configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb
    configtxlator compute_update --channel_id mychannel  --original config.pb --updated modified_config.pb --output config_update.pb

}

convertConfigDeltaToJSON(){   
        getGlobalPeer0Org1 
        echo
        echo "converting configDelta to json...."
        echo
        configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate | jq . > config_update.json
          
        echo '{"payload":{"header":{"channel_header":{"channel_id":"mychannel", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . > config_update_in_envelope.json

        configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope --output config_update_in_envelope.pb

}

updatesSignByOrg1(){
    echo 
    echo "org3 update sign by org1"
    getGlobalPeer0Org1
    peer channel signconfigtx -f config_update_in_envelope.pb
}


fetchConfig     
sleep 2
convertToJson

sleep 2

addOrg3

sleep 2
computeDeltas
sleep 2
convertConfigDeltaToJSON
sleep 2
updatesSignByOrg1

