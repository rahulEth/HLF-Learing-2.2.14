### different policies in configtx.yaml files

1. Readers: Readers section defines who have access to the channel's configration.
this includes entities that are allowed to query the channel configration , such as 
peer and clients

Example:

Readers:
   Type: implicitMeta
   Rule: "Any Readers"

This policy allows any entity (identified by their MSP identity) to read the channel configuration.


2. Writers: The Writers section defines who has write access to the channel's configration. this includes entites that are allowed to submit configration update to the channel.

Example:

Writers:
  Type: ImplicitMeta
  Rule: "ANY Writers"

this policy allow any entity (identified by thier MSP identity) to write to the channel configration.

such as 
a. order org admins

Writers:
  Type: Signature
  Rule: "OR('OrdererMSP.admin')"

b. channel application admins( orgs admin )   

admins of channel's application orgs may have access to propose and approve the channel configration updated like Bank, Insurance Company, healthcare company etc. 

c. channel Operator Users: specific users designated as channel operator can have config update access.
Ex

Writers:
   Types: Signature
   Rule: "OR('Org1MSP.operator', 'Org2MSP.operator', '....')"

d. Application Clients: clients that interacts with network's applications( like chaincode, client application, Transaction Processing Logic, UI or other external s/s integrated with network's app) may have write access on behalf on their org

EX
Writers:
   Types: Signature
   Rule: "OR('Org1MSP.client', 'Org2MSP.client', '.....')"

3. Admins: this section defines who have admin access can modifed the channel config or perform administrative task

Ex:

Admins:
   Type: ImplicitMeta
   Rules: "Majority Admins"

4. AdminPolicy: this section defines identities that can authorize the configration updates. i.e who can approve the channel configration transactions

Ex: 

AdminPolicy:
   Type: Signature
   Rule: "OR('Org1MSP.admin', 'Org2MSP.admin')"  

5. LifecycleEndorsement: used duing lifecycle  mgmt of chaincode. it defines cretria for endorsing the chaincode package.
LifecycleEndorsement:
  Type: ImplicitMeta
  Rule: "MAJORITY Endorsement"

6. Endorsment: defines the cretria for endorsing individual transactions that invoke chaincode logic to make transaction valid

Endorsement:
  Type: Signature
  Rule: "OR('Org1MSP.peer','Org2MSP.peer')"



Type Field in each Policy Section: it determines how the policy is evaluated and which rules are applied to determine weather the policy is satisfied.

1. Signature: this type specifed one or more signature from specified identites
like admin, peers, clients
Example: Type: Signature
2. ImplicitMeta: number of identites that satisfy the specified rule. like ANY, ALL, MAJORITY
Example: Type: ImplicitMeta

3. Channel/Application ACL: this defines Aceess control Logic for specific action or operation within the channel or application, like which identify have read, write or invoke acess.
Example: Type: ACL

4. Lifecycle: for lifecycle management operations( like chaincode installation, approval) .defines rules for lifecycle.
Example: Type: Lifecycle

5. Hash: this type ensure hash of current configration matches a predefined hash valule.

Example: Type: Hash



### CSR(Certificate Signing Request)

csr is an message sent from applicat to CA for a digital identity certificate. 
CSR contains information about the entity requesting the certificate and is used by the CA to generate certificate that asserts the identity of the applicant.

1. content of CRT: it contain public key, DN(distinguished name): info about the entity like common name , orgnization, country

2. usages in HLF
a. Identity Enrollment : CA uses CSR information to issue certificate
b. Reenrollment
c. tls certificate issuence 

Example CSR Attributes:

Common Name(CN) : the name of the identity (like admin, peer0.org1.exampel.com, order.example.com)

Orgnization(O): the org name to which the identiy belongs
Orgnization Unit(OU): the unit within the orgnization 
County(C): like US
State(S): like North California
Locality(L): Raleigh

Orgnization Unit(OU): 
OU for peer Nodes
OU: peers
OU for client apps
OU for different department 
OU: finance
OU for different project team
OU: project_alpha
OU for different geo location
OU: london

OU for different business unit 
OU: sales

csr file example

csr:
  cn: peer0.org1.example.com
  names:
    - C: US
      ST: California
      L: San Francisco
      O: Org1
      OU: peers
      OU: IT
  hosts:
    - peer0.org1.example.com
    - localhost


## what is CORE_OPERATIONS_LISTENADDRESS

this is called operational end point. this is used for monitoring and managing (like metrics, heatlh checkes, and logging endponts)the peer or orderer. using port we expose the peer to network
Ex: 
export CORE_OPERATIONS_LISTENADDRESS=127.0.0.1:9443

tls configration in core.yaml

operations:
  listenAddress: 127.0.0.1:9443
  tls:
    enabled: true
    cert:
      file: /path/to/tls-cert.pem
    key:
      file: /path/to/tls-key.pem
    clientAuthRequired: false
    clientRootCAs:
      files:


Metrics and Health Checks

* Metrics: Accessible at http://127.0.0.1:9443/metrics (or https if TLS is enabled).
* Health Check: Accessible at http://127.0.0.1:9443/healthz (or https if TLS is enabled).

Access metrics:
a. curl http://127.0.0.1:9443/metrics

b. if tls enable
export CORE_OPERATIONS_TLS_ENABLED=true
export CORE_OPERATIONS_TLS_CERT_FILE=/path/to/tls-cert.pem
export CORE_OPERATIONS_TLS_KEY_FILE=/path/to/tls-key.pem

curl --cacert /path/to/ca-cert.pem https://127.0.0.1:9443/metrics


Access health:
curl http://127.0.0.1:9443/healthz
{"status":"OK","time":"2024-05-18T06:29:35.78243052Z"}


















