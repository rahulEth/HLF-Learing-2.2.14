## Running the test network

You can use the `./network.sh` script to stand up a simple Fabric test network. The test network has two peer organizations with one peer each and a single node raft ordering service. You can also use the `./network.sh` script to create channels and deploy chaincode. For more information, see [Using the Fabric test network](https://hyperledger-fabric.readthedocs.io/en/latest/test_network.html). The test network is being introduced in Fabric v2.0 as the long term replacement for the `first-network` sample.

Before you can deploy the test network, you need to follow the instructions to [Install the Samples, Binaries and Docker Images](https://hyperledger-fabric.readthedocs.io/en/latest/install.html) in the Hyperledger Fabric documentation.


###   shebang or hashbang

`#!/usr/bin/env bash`

where #! = hashbang
/usr/bin/env = path to the interprarter from where interpreter should run
bash = name of the interpreter


`-M or --mspdir: mspdir name`
`csr.hosts: a list of coma seperated host names in a certificate signing request`
`--enrollment.profile: name of the signing profile to use in issuing the certificate`
`--enrollment.type: the type of enrollment request: like x509, idemix default is x509`
`--id.name: a unique name of identity`
`--id.type: type of identity being registered for ex peer, app, user default is client`
`--id.secret: the enrollment secret for the identify being registered`
`-u or --url: URL of fabric-ca-server (default "http://localhost:7054")`





### docker commands

#### delete stoped container
`docker container prune`

### delete unused volume
`docker volume prune`



