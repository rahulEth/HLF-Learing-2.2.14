
#!/usr/bin/env bash
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx
export VERBOSE=false

configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/mychannel2.tx -channelID "mychannel2"