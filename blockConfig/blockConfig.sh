orgname=OrdererOrg
channel=mychannel
port=7050
domain=orderer.example.com
batchMessageSize=30
batchTimeout="1s"
export PATH=${PWD}/../bin:$PATH

export FABRIC_LOGGING_SPEC=INFO
export CORE_PEER_TLS_ENABLED=true
export FABRIC_CFG_PATH=${PWD}/../config
export ORDERER_CA=${PWD}/../orderer/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/tls-localhost-9054-ca-orderer.pem
export CORE_PEER_TLS_CERT_FILE=${PWD}/../orderer/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=${PWD}/../orderer/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key
export CORE_PEER_LOCALMSPID=OrdererMSP
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../orderer/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/../orderer/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp
export CORE_PEER_ADDRESS=$domain:$port

getConfig(){
        peer channel fetch config config_block.pb -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com  -c $channel --tls --cafile $ORDERER_CA

}
convertBlockToJSON(){
        configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json
}
modifyBatchTimeout(){

	jq  ".channel_group.groups.Orderer.values.BatchTimeout.value.timeout = $batchTimeout " config.json > modified_config.json

}
modifyBatchSize(){
	jq ".channel_group.groups.Orderer.values.BatchSize.value.max_message_count = $batchMessageSize " config.json > modified_config.json
}
computeDelta(){

        configtxlator proto_encode --input config.json --type common.Config --output config.pb

        configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb

        configtxlator compute_update --channel_id $channel --original config.pb --updated modified_config.pb --output config_update.pb
}

convertConfigDeltaToJSON(){

    configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate --output config_update.json

	echo '{"payload":{"header":{"channel_header":{"channel_id":"mychannel", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . > config_update_in_envelope.json

    configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope --output config_update_in_envelope.pb

}
signEnvolope(){

        peer channel signconfigtx -f config_update_in_envelope.pb
}

updateChannel(){
        peer channel update -f config_update_in_envelope.pb -c $channel -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com  --tls --cafile $ORDERER_CA 
}

# getConfig
# sleep 2
# convertBlockToJSON
# sleep 2
#modifyBatchTimeout
# modifyBatchSize
# sleep 2
# computeDelta
# sleep 2
# convertConfigDeltaToJSON
# sleep 2
# signEnvolope
# sleep 2
# updateChannel
# sleep 2