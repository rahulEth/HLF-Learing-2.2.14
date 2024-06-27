export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/org1.example.com/
export PATH=${PWD}/../../bin:$PATH
registerPeer() {
  echo
  echo "Register peer2"
  echo
  fabric-ca-client register --caname ca.org1.example.com --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/org1/tls-cert.pem

}

createMSPPeer2() {
  # Peer2

  mkdir -p peerOrganizations/org1.example.com/peers/peer2.org1.example.com

  echo
  echo "## Generate the peer2 msp"
  echo
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:7054 --caname ca.org1.example.com -M ${PWD}/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/msp --csr.hosts peer2.org1.example.com --tls.certfiles ${PWD}/../organizations/fabric-ca/org1/tls-cert.pem

  sleep 5
  cp ${PWD}/../organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/msp/config.yaml

  echo
  echo "## Generate the peer2-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:7054 --caname ca.org1.example.com -M ${PWD}/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls --enrollment.profile tls --csr.hosts peer2.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/org1/tls-cert.pem
  sleep 5
  cp ${PWD}/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/tlscacerts/* ${PWD}/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/ca.crt
  cp ${PWD}/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/signcerts/* ${PWD}/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/server.crt
  cp ${PWD}/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/keystore/* ${PWD}/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/server.key

  # --------------------------------------------------------------------------------------------------

}
# registerPeer
sleep 2
createMSPPeer2