Adding an org
======================

Create folder to store data in
```bash
export ENVIRONMENT=production
export NEW_ORG_NAME=dell
export FOLDER_PATH=configs/${ENVIRONMENT}/${NEW_ORG_NAME}
rm -rf $FOLDER_PATH
mkdir -p $FOLDER_PATH/cas
mkdir -p $FOLDER_PATH/cli
mkdir -p $FOLDER_PATH/couchdb
mkdir -p $FOLDER_PATH/peers
```


Organizations:
    - &orderer
        Name: orderer
        ID: orderer
        MSPDir: /host/files/crypto-config/ordererOrganizations/orderer/msp
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('orderer.member')"
            Writers:
                Type: Signature
                Rule: "OR('orderer.member')"
            Admins:
                Type: Signature
                Rule: "OR('orderer.admin')"
    - &ibm
        Name: ibm
        ID: ibm
        MSPDir: /host/files/crypto-config/peerOrganizations/ibm/msp
        AnchorPeers:
            - Host: peer0-ibm-service
              Port: 7051
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('ibm.member')"
            Writers:
                Type: Signature
                Rule: "OR('ibm.member')"
            Admins:
                Type: Signature
                Rule: "OR('ibm.admin')"
            Endorsement:
                Type: Signature
                Rule: "OR('ibm.member')"
    - &oracle
        Name: oracle
        ID: oracle
        MSPDir: /host/files/crypto-config/peerOrganizations/oracle/msp
        AnchorPeers:
            - Host: peer0-oracle-service
              Port: 7051
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('oracle.member')"
            Writers:
                Type: Signature
                Rule: "OR('oracle.member')"
            Admins:
                Type: Signature
                Rule: "OR('oracle.admin')"
            Endorsement:
                Type: Signature
                Rule: "OR('oracle.member')"
    - &hp
        Name: hp
        ID: hp
        MSPDir: /host/files/crypto-config/peerOrganizations/hp/msp
        AnchorPeers:
            - Host: peer0-hp-service
              Port: 7051
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('hp.member')"
            Writers:
                Type: Signature
                Rule: "OR('hp.member')"
            Admins:
                Type: Signature
                Rule: "OR('hp.admin')"
            Endorsement:
                Type: Signature
                Rule: "OR('hp.member')"

Capabilities:
    Global: &ChannelCapabilities
        V2_0: true
    Orderer: &OrdererCapabilities
        V2_0: true
    Application: &ApplicationCapabilities
        V2_0: true

Application: &ApplicationDefaults
    Organizations:
    Policies:
        Readers:
            Type: ImplicitMeta
            Rule: "ANY Readers"
        Writers:
            Type: ImplicitMeta
            Rule: "ANY Writers"
        Admins:
            Type: ImplicitMeta
            Rule: "MAJORITY Admins"
        LifecycleEndorsement:
            Type: ImplicitMeta
            Rule: "ANY Endorsement"
        Endorsement:
            Type: ImplicitMeta
            Rule: "ANY Endorsement"
    Capabilities:
        <<: *ApplicationCapabilities

Orderer: &OrdererDefaults
    OrdererType: etcdraft
    EtcdRaft:
        Consenters:
            - Host: orderer0-service
              Port: 7050
              ClientTLSCert: /host/files/crypto-config/ordererOrganizations/orderer/orderers/orderer0/tls/server.crt
              ServerTLSCert: /host/files/crypto-config/ordererOrganizations/orderer/orderers/orderer0/tls/server.crt
            - Host: orderer1-service
              Port: 7050
              ClientTLSCert: /host/files/crypto-config/ordererOrganizations/orderer/orderers/orderer1/tls/server.crt
              ServerTLSCert: /host/files/crypto-config/ordererOrganizations/orderer/orderers/orderer1/tls/server.crt
            - Host: orderer2-service
              Port: 7050
              ClientTLSCert: /host/files/crypto-config/ordererOrganizations/orderer/orderers/orderer2/tls/server.crt
              ServerTLSCert: /host/files/crypto-config/ordererOrganizations/orderer/orderers/orderer2/tls/server.crt
    Addresses:
        - orderer0:7050-service
        - orderer1:7050-service
        - orderer2:7050-service
    BatchTimeout: 2s
    BatchSize:
        MaxMessageCount: 10
        AbsoluteMaxBytes: 99 MB
        PreferredMaxBytes: 512 KB
    Kafka:
        Brokers:
            - 127.0.0.1:9092
    Organizations:
        - *orderer
    Policies:
        Readers:
            Type: ImplicitMeta
            Rule: "ANY Readers"
        Writers:
            Type: ImplicitMeta
            Rule: "ANY Writers"
        Admins:
            Type: ImplicitMeta
            Rule: "MAJORITY Admins"
        BlockValidation:
            Type: ImplicitMeta
            Rule: "ANY Writers"

Channel: &ChannelDefaults
    Policies:
        Readers:
            Type: ImplicitMeta
            Rule: "ANY Readers"
        Writers:
            Type: ImplicitMeta
            Rule: "ANY Writers"
        Admins:
            Type: ImplicitMeta
            Rule: "MAJORITY Admins"
    Capabilities:
        <<: *ChannelCapabilities

Profiles:
    MainChannel:
        Consortium: MAIN
        <<: *ChannelDefaults
        Application:
            <<: *ApplicationDefaults
            Organizations:
                - *ibm
                - *oracle
                - *hp
            Capabilities:
                <<: *ApplicationCapabilities



Create necessary files
```bash
cat <<EOT > ${FOLDER_PATH}/configtx.yaml
Organizations:
    - &orderer
        Name: orderer
        ID: orderer
        MSPDir: /host/files/crypto-config/ordererOrganizations/orderer/msp
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('orderer.member')"
            Writers:
                Type: Signature
                Rule: "OR('orderer.member')"
            Admins:
                Type: Signature
                Rule: "OR('orderer.admin')"
    - &ibm
        Name: ibm
        ID: ibm
        MSPDir: /host/files/crypto-config/peerOrganizations/ibm/msp
        AnchorPeers:
            - Host: peer0-ibm-service
              Port: 7051
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('ibm.member')"
            Writers:
                Type: Signature
                Rule: "OR('ibm.member')"
            Admins:
                Type: Signature
                Rule: "OR('ibm.admin')"
            Endorsement:
                Type: Signature
                Rule: "OR('ibm.member')"
    - &oracle
        Name: oracle
        ID: oracle
        MSPDir: /host/files/crypto-config/peerOrganizations/oracle/msp
        AnchorPeers:
            - Host: peer0-oracle-service
              Port: 7051
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('oracle.member')"
            Writers:
                Type: Signature
                Rule: "OR('oracle.member')"
            Admins:
                Type: Signature
                Rule: "OR('oracle.admin')"
            Endorsement:
                Type: Signature
                Rule: "OR('oracle.member')"
    - &hp
        Name: hp
        ID: hp
        MSPDir: /host/files/crypto-config/peerOrganizations/hp/msp
        AnchorPeers:
            - Host: peer0-hp-service
              Port: 7051
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('hp.member')"
            Writers:
                Type: Signature
                Rule: "OR('hp.member')"
            Admins:
                Type: Signature
                Rule: "OR('hp.admin')"
            Endorsement:
                Type: Signature
                Rule: "OR('hp.member')"

    - &${NEW_ORG_NAME}
        Name: ${NEW_ORG_NAME}
        ID: ${NEW_ORG_NAME}
        MSPDir: /host/files/crypto-config/peerOrganizations/${NEW_ORG_NAME}/msp
        AnchorPeers:
            - Host: peer0-${NEW_ORG_NAME}-service
              Port: 7051
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('${NEW_ORG_NAME}.member')"
            Writers:
                Type: Signature
                Rule: "OR('${NEW_ORG_NAME}.member')"
            Admins:
                Type: Signature
                Rule: "OR('${NEW_ORG_NAME}.admin')"
            Endorsement:
                Type: Signature
                Rule: "OR('${NEW_ORG_NAME}.member')"

Capabilities:
    Global: &ChannelCapabilities
        V2_0: true
    Orderer: &OrdererCapabilities
        V2_0: true
    Application: &ApplicationCapabilities
        V2_0: true

Application: &ApplicationDefaults
    Organizations:
    Policies:
        Readers:
            Type: ImplicitMeta
            Rule: "ANY Readers"
        Writers:
            Type: ImplicitMeta
            Rule: "ANY Writers"
        Admins:
            Type: ImplicitMeta
            Rule: "MAJORITY Admins"
        LifecycleEndorsement:
            Type: ImplicitMeta
            Rule: "ANY Endorsement"
        Endorsement:
            Type: ImplicitMeta
            Rule: "ANY Endorsement"
    Capabilities:
        <<: *ApplicationCapabilities

Orderer: &OrdererDefaults
    OrdererType: etcdraft
    EtcdRaft:
        Consenters:
            - Host: orderer0-service
              Port: 7050
              ClientTLSCert: /host/files/crypto-config/ordererOrganizations/orderer/orderers/orderer0/tls/server.crt
              ServerTLSCert: /host/files/crypto-config/ordererOrganizations/orderer/orderers/orderer0/tls/server.crt
            - Host: orderer1-service
              Port: 7050
              ClientTLSCert: /host/files/crypto-config/ordererOrganizations/orderer/orderers/orderer1/tls/server.crt
              ServerTLSCert: /host/files/crypto-config/ordererOrganizations/orderer/orderers/orderer1/tls/server.crt
            - Host: orderer2-service
              Port: 7050
              ClientTLSCert: /host/files/crypto-config/ordererOrganizations/orderer/orderers/orderer2/tls/server.crt
              ServerTLSCert: /host/files/crypto-config/ordererOrganizations/orderer/orderers/orderer2/tls/server.crt
    Addresses:
        - orderer0:7050-service
        - orderer1:7050-service
        - orderer2:7050-service
    BatchTimeout: 2s
    BatchSize:
        MaxMessageCount: 10
        AbsoluteMaxBytes: 99 MB
        PreferredMaxBytes: 512 KB
    Kafka:
        Brokers:
            - 127.0.0.1:9092
    Organizations:
        - *orderer
    Policies:
        Readers:
            Type: ImplicitMeta
            Rule: "ANY Readers"
        Writers:
            Type: ImplicitMeta
            Rule: "ANY Writers"
        Admins:
            Type: ImplicitMeta
            Rule: "MAJORITY Admins"
        BlockValidation:
            Type: ImplicitMeta
            Rule: "ANY Writers"

Channel: &ChannelDefaults
    Policies:
        Readers:
            Type: ImplicitMeta
            Rule: "ANY Readers"
        Writers:
            Type: ImplicitMeta
            Rule: "ANY Writers"
        Admins:
            Type: ImplicitMeta
            Rule: "MAJORITY Admins"
    Capabilities:
        <<: *ChannelCapabilities

Profiles:
    DellChannel:
        Consortium: MAIN
        <<: *ChannelDefaults
        Application:
            <<: *ApplicationDefaults
            Organizations:
                - *ibm
                - *oracle
                - *hp
                - *${NEW_ORG_NAME}
            Capabilities:
                <<: *ApplicationCapabilities

EOT


cat <<EOT > ${FOLDER_PATH}/cas/${NEW_ORG_NAME}-ca-client-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${NEW_ORG_NAME}-ca-client
  labels: {
    component: ${NEW_ORG_NAME}-ca-client,
    type: ca
  }
spec:
  replicas: 1
  selector:
    matchLabels:
      component: ${NEW_ORG_NAME}-ca-client
      type: ca
  template:
    metadata:
      labels:
        component: ${NEW_ORG_NAME}-ca-client
        type: ca
    spec:
      volumes:
        - name: my-pv-storage
          persistentVolumeClaim:
            claimName: my-pv-claim
      containers:
        - name: ${NEW_ORG_NAME}-ca-client
          image: hyperledger/fabric-ca:1.4.7
          command: ["bash"]
          args: ["/scripts/start-org-client.sh"]
          env:
            - name: FABRIC_CA_SERVER_HOME
              value: /etc/hyperledger/fabric-ca-client
            - name: ORG_NAME
              value: ${NEW_ORG_NAME}
            - name: CA_SCHEME
              value: https
            - name: CA_URL
              value: "${NEW_ORG_NAME}-ca-service:7054"
            - name: CA_USERNAME
              value: admin
            - name: CA_PASSWORD
              value: adminpw
            - name: CA_CERT_PATH
              value: /etc/hyperledger/fabric-ca-server/tls-cert.pem
          volumeMounts:
            - mountPath: /scripts
              name: my-pv-storage
              subPath: files/scripts
            - mountPath: /state
              name: my-pv-storage
              subPath: state
            - mountPath: /files
              name: my-pv-storage
              subPath: files
            - mountPath: /etc/hyperledger/fabric-ca-server
              name: my-pv-storage
              subPath: state/${NEW_ORG_NAME}-ca
            - mountPath: /etc/hyperledger/fabric-ca-client
              name: my-pv-storage
              subPath: state/${NEW_ORG_NAME}-ca-client
            - mountPath: /etc/hyperledger/fabric-ca/crypto-config
              name: my-pv-storage
              subPath: files/crypto-config
EOT

cat <<EOT > ${FOLDER_PATH}/cas/${NEW_ORG_NAME}-ca-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${NEW_ORG_NAME}-ca
  labels: {
    component: ${NEW_ORG_NAME},
    type: ca
  }
spec:
  replicas: 1
  selector:
    matchLabels:
      component: ${NEW_ORG_NAME}
      type: ca
  template:
    metadata:
      labels:
        component: ${NEW_ORG_NAME}
        type: ca
    spec:
      volumes:
        - name: my-pv-storage
          persistentVolumeClaim:
            claimName: my-pv-claim
      containers:
        - name: ${NEW_ORG_NAME}-ca
          image: hyperledger/fabric-ca:1.4.7
          command: ["sh"]
          args: ["/scripts/start-root-ca.sh"]
          ports:
            - containerPort: 7054
          env:
            - name: FABRIC_CA_HOME
              value: /etc/hyperledger/fabric-ca-server
            - name: USERNAME
              value: admin
            - name: PASSWORD
              value: adminpw
            - name: CSR_HOSTS
              value: ${NEW_ORG_NAME}-ca
          volumeMounts:
            - mountPath: /scripts
              name: my-pv-storage
              subPath: files/scripts
            - mountPath: /etc/hyperledger/fabric-ca-server
              name: my-pv-storage
              subPath: state/${NEW_ORG_NAME}-ca

EOT

cat <<EOT > ${FOLDER_PATH}/cas/${NEW_ORG_NAME}-ca-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: ${NEW_ORG_NAME}-ca-service
  labels: {
    component: ${NEW_ORG_NAME},
    type: ca
  }
spec:
  type: ClusterIP
  selector:
    component: ${NEW_ORG_NAME}
    type: ca
  ports:
    - port: 7054
      targetPort: 7054

EOT
```

Next, we need to update the private data
```bash
cat <<EOT > chaincode/resource_types/collections-config.json
[
    {
        "name": "ibmResourceTypesPrivateData",
        "policy": "OR('ibm.member')",
        "requiredPeerCount": 1,
        "maxPeerCount": 3,
        "blockToLive": 0
    },
    {
        "name": "oracleResourceTypesPrivateData",
        "policy": "OR('oracle.member')",
        "requiredPeerCount": 1,
        "maxPeerCount": 3,
        "blockToLive": 0
    },
    {
        "name": "${NEW_ORG_NAME}ResourceTypesPrivateData",
        "policy": "OR('${NEW_ORG_NAME}.member')",
        "requiredPeerCount": 1,
        "maxPeerCount": 3,
        "blockToLive": 0
    }
]
EOT

cat <<EOT > chaincode/resources/collections-config.json
[
    {
        "name": "ibmResourcesPrivateData",
        "policy": "OR('ibm.member')",
        "requiredPeerCount": 1,
        "maxPeerCount": 3,
        "blockToLive": 0
    },
    {
        "name": "oracleResourcesPrivateData",
        "policy": "OR('oracle.member')",
        "requiredPeerCount": 1,
        "maxPeerCount": 3,
        "blockToLive": 0
    },
    {
        "name": "${NEW_ORG_NAME}ResourcesPrivateData",
        "policy": "OR('${NEW_ORG_NAME}.member')",
        "requiredPeerCount": 1,
        "maxPeerCount": 3,
        "blockToLive": 0
    }
]
EOT


Start hp ca and create certs
```bash
kubectl apply -f ${FOLDER_PATH}/cas
sleep 20
```

Time to copy over changed files
```bash
kubectl cp ${FOLDER_PATH}/configtx.yaml $(kubectl get pods -o=name | grep example1 | sed "s/^.\{4\}//"):/host/files
kubectl cp ./chaincode/resources $(kubectl get pods -o=name | grep example1 | sed "s/^.\{4\}//"):/host/files/chaincode
kubectl cp ./chaincode/resource_types $(kubectl get pods -o=name | grep example1 | sed "s/^.\{4\}//"):/host/files/chaincode
```

Get the config from the configtx (NOTE: There isn't really a way to pass in ENV into a kubectl command easily. Just do it manually) (In this example, I just hardcoded the orgName in the configtxgen command for "hp")
TODO: Create a script for this with the org name and then copy it and run it in the container
```bash
kubectl exec -it $(kubectl get pods -o=name | grep example1 | sed "s/^.\{4\}//") bash
...
cd /host/files

bin/configtxgen -printOrg dell > ./channels/dell.json
```

Use an existing org to get the current config
```bash
kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'apk update'
kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'apk add jq'
sleep 1

kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'peer channel fetch config sys_config_block.pb -c syschannel -o orderer0-service:7050 --tls --cafile=/var/hyperledger/orderer/msp/tlscacerts/tlsca.orderer-cert.pem'

sleep 1
kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'configtxlator proto_decode --input sys_config_block.pb --type common.Block | jq .data.data[0].payload.data.config > sys_config_block.json'

jq .data.data[0].payload.data.config sys_config_block.json > sys_config.json


sleep 1
cat <<EOT > scripts/consum_modified_config.sh
#!/bin/bash

jq -s '.[0] * {"channel_group":{"groups":{"Consortiums":{"groups": {"MAIN": {"groups": {"dell":.[1]}}}}}}}’ sys_config_block.json ../dell.json >& consum_modified_config.json
EOT

chmod +x scripts/consum_modified_config.sh

kubectl cp ./scripts $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//"):/opt/gopath/src/github.com/hyperledger/fabric/orderer

kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c './scripts/consum_modified_config.sh'
sleep 1

kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'configtxlator proto_encode --input sys_config.json --type common.Config --output sys_config.pb'

sleep 1
kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'configtxlator proto_encode --input consum_modified_config.json --type common.Config --output consum_modified_config.pb'
sleep 1

kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c '\
	configtxlator compute_update \
	--channel_id syschannel \
	--original sys_config.pb \
	--updated consum_modified_config.pb \
	--output diff_config.pb'

sleep 1
kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c '\
	configtxlator proto_decode \
	--input diff_config.pb \
	--type common.ConfigUpdate | jq . > diff_config.json \
	'
cat <<EOT > scripts/create-org-envelope.sh
#!/bin/bash

'{"payload":{"header":{"channel_header":{"channel_id":"mychannel", "type":2}},"data":{"config_update":’$(cat org_update.json)’}}}’ | jq . > diff_config_envelope.json

EOT

sleep 1
kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c './scripts/create-org-envelope.sh'
sleep 1


kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c '\
	configtxlator proto_encode --input diff_config_envelope.json --type common.Envelope --output diff_config_envelope.pb \
	'
sleep 1
kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c '\
	peer channel signconfigtx -f diff_config_envelope.pb \
	'
sleep 1
kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c '\
	cp diff_config_envelope.pb channels/diff_config_envelope.pb \
	'
sleep 1

kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-oracle-deployment | sed "s/^.\{4\}//") -- bash -c '\
	peer channel update -f channels/diff_config_envelope.pb -c syschannel -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem \
	'

```
=====================================================================
Okay, so now we've updated the existing config with the new org. Time to startup the new org

Let's bring up the third org (NOTE: Ensure each group is up before adding the next)
```bash
kubectl apply -f $FOLDER_PATH/couchdb
sleep 30
kubectl apply -f $FOLDER_PATH/peers
sleep 30
kubectl apply -f $FOLDER_PATH/cli
```

Time to join the peers to the network
```bash

kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer channel join -b channels/mainchannel.block'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer1-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer channel join -b channels/mainchannel.block'
```

Time to install resource_types chaincode for the 3rd org: TODO: figure out how to get the current sequence number and use it for this new org
```bash
kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode package resource_types.tar.gz --path /opt/gopath/src/resource_types --lang golang --label resource_types_2'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer1-ibm-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode package resource_types.tar.gz --path /opt/gopath/src/resource_types --lang golang --label resource_types_2'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-oracle-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode package resource_types.tar.gz --path /opt/gopath/src/resource_types --lang golang --label resource_types_2'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer1-oracle-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode package resource_types.tar.gz --path /opt/gopath/src/resource_types --lang golang --label resource_types_2'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode package resource_types.tar.gz --path /opt/gopath/src/resource_types --lang golang --label resource_types_2'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer1-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode package resource_types.tar.gz --path /opt/gopath/src/resource_types --lang golang --label resource_types_2'


kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode install resource_types.tar.gz &> pkg.txt'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer1-ibm-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode install resource_types.tar.gz'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-oracle-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode install resource_types.tar.gz &> pkg.txt'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer1-oracle-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode install resource_types.tar.gz'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode install resource_types.tar.gz &> pkg.txt'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer1-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode install resource_types.tar.gz'


kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode approveformyorg -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem --collections-config /opt/gopath/src/resource_types/collections-config.json --channelID mainchannel --name resource_types --version 2.0 --sequence 2 --package-id $(tail -n 1 pkg.txt | awk '\''NF>1{print $NF}'\'')'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-oracle-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode approveformyorg -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem --collections-config /opt/gopath/src/resource_types/collections-config.json --channelID mainchannel --name resource_types --version 2.0 --sequence 2 --package-id $(tail -n 1 pkg.txt | awk '\''NF>1{print $NF}'\'')'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode approveformyorg -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem --collections-config /opt/gopath/src/resource_types/collections-config.json --channelID mainchannel --name resource_types --version 2.0 --sequence 2 --package-id $(tail -n 1 pkg.txt | awk '\''NF>1{print $NF}'\'')'

kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode commit -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem --collections-config /opt/gopath/src/resource_types/collections-config.json --channelID mainchannel --name resource_types --version 2.0 --sequence 2'
```

Lets test this chaincode
```bash
kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'peer chaincode query -C mainchannel -n resource_types -c '\''{"Args":["Index"]}'\'' -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-oracle-deployment | sed "s/^.\{4\}//") -- bash -c 'peer chaincode query -C mainchannel -n resource_types -c '\''{"Args":["Index"]}'\'' -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer chaincode query -C mainchannel -n resource_types -c '\''{"Args":["Index"]}'\'' -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem'
```

Time to install resources chaincode for the 3rd org (Need to use the NEXT seq number)
```bash
kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode package resources.tar.gz --path /opt/gopath/src/resources --lang golang --label resources_2'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer1-ibm-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode package resources.tar.gz --path /opt/gopath/src/resources --lang golang --label resources_2'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-oracle-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode package resources.tar.gz --path /opt/gopath/src/resources --lang golang --label resources_2'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer1-oracle-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode package resources.tar.gz --path /opt/gopath/src/resources --lang golang --label resources_2'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode package resources.tar.gz --path /opt/gopath/src/resources --lang golang --label resources_2'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer1-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode package resources.tar.gz --path /opt/gopath/src/resources --lang golang --label resources_2'


kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode install resources.tar.gz &> pkg.txt'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer1-ibm-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode install resources.tar.gz'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-oracle-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode install resources.tar.gz &> pkg.txt'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer1-oracle-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode install resources.tar.gz'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode install resources.tar.gz &> pkg.txt'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer1-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode install resources.tar.gz'


kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode approveformyorg -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem --collections-config /opt/gopath/src/resources/collections-config.json --channelID mainchannel --name resources --version 2.0 --sequence 2 --package-id $(tail -n 1 pkg.txt | awk '\''NF>1{print $NF}'\'')'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-oracle-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode approveformyorg -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem --collections-config /opt/gopath/src/resources/collections-config.json --channelID mainchannel --name resources --version 2.0 --sequence 2 --package-id $(tail -n 1 pkg.txt | awk '\''NF>1{print $NF}'\'')'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode approveformyorg -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem --collections-config /opt/gopath/src/resources/collections-config.json --channelID mainchannel --name resources --version 2.0 --sequence 2 --package-id $(tail -n 1 pkg.txt | awk '\''NF>1{print $NF}'\'')'



kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'peer lifecycle chaincode commit -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem --collections-config /opt/gopath/src/resources/collections-config.json --channelID mainchannel --name resources --version 2.0 --sequence 2'
```

Lets test this chaincode
```bash
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer chaincode invoke -C mainchannel -n resources -c '\''{"Args":["Create","PCs","1"]}'\'' -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer chaincode invoke -C mainchannel -n resources -c '\''{"Args":["Create","Printers","1"]}'\'' -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem'
sleep 5
kubectl exec -it $(kubectl get pods -o=name | grep cli-orderer0-deployment | sed "s/^.\{4\}//") -- bash -c 'peer chaincode query -C mainchannel -n resources -c '\''{"Args":["Index"]}'\'' -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-oracle-deployment | sed "s/^.\{4\}//") -- bash -c 'peer chaincode query -C mainchannel -n resources -c '\''{"Args":["Index"]}'\'' -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem'
kubectl exec -it $(kubectl get pods -o=name | grep cli-peer0-hp-deployment | sed "s/^.\{4\}//") -- bash -c 'peer chaincode query -C mainchannel -n resources -c '\''{"Args":["Index"]}'\'' -o orderer0-service:7050 --tls --cafile=/etc/hyperledger/orderers/msp/tlscacerts/orderers-ca-service-7054.pem'
```

