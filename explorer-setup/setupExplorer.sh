rm -rf dockerConfig/organizations

mkdir -p dockerConfig/organizations
cp config.json dockerConfig/
cp -r connection-profile dockerConfig/
cp -r ../orderer/organizations/ordererOrganizations/ dockerConfig/organizations/
cp -r ../org1/organizations/peerOrganizations/ dockerConfig/organizations/
cp -r ../org2/organizations/peerOrganizations/ dockerConfig/organizations/
sleep 5
docker-compose -f docker-compose-explorer.yaml up -d
sleep 10
docker ps -a