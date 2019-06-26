    CHANNEL_NAME1="channel1"
    CHANNEL_NAME2="channel2"
    CHANNEL_NAME3="channel3"
    CLI_DELAY=3
    CLI_TIMEOUT=10
    LANGUAGE=node
    VERBOSE=true
    VERSION=1.0
    #peer chaincode query -C channel1 -n License -c '{"function":"AllIssue","Args":[]}'
    TEST_CHAINCODE="/opt/gopath/src/github.com/chaincode/license/" 

    ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    PEER0_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
    PEER0_ORG2_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
    PEER0_ORG3_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
    PEER0_ORG4_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt
    PEER0_ORG5_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.example.com/peers/peer0.org5.example.com/tls/ca.crt

    peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME1 -f ./channel-artifacts/channel1.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA 
    peer channel join -b $CHANNEL_NAME1.block

    peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME1 -f ./channel-artifacts/CH1Org5MSPanchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

    CORE_PEER_LOCALMSPID="Org4MSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG4_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp
    CORE_PEER_ADDRESS=peer0.org4.example.com:7051 
    peer channel join -b $CHANNEL_NAME1.block


    peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME1 -f ./channel-artifacts/CH1Org4MSPanchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    peer chaincode install -n License -v $VERSION -l node -p $TEST_CHAINCODE 

    CORE_PEER_LOCALMSPID="Org5MSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG5_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.example.com/users/Admin@org5.example.com/msp
    CORE_PEER_ADDRESS=peer0.org5.example.com:7051 

    peer chaincode install -n License -v $VERSION -l node -p $TEST_CHAINCODE 
    peer chaincode instantiate -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA  --peerAddresses peer0.org5.example.com:7051 --tlsRootCertFiles $PEER0_ORG5_CA  -C $CHANNEL_NAME1 -n License -l ${LANGUAGE} -v ${VERSION} -c  '{"Args":["initLedger"]}' -P "OR ('Org5MSP.member','Org4MSP.member')" 



VERSION=1.0
LANGUAGE=node
CHANNEL_NAME1="channel1"
peer chaincode install -n License -v $VERSION -l node -p $TEST_CHAINCODE 

peer chaincode upgrade -C channel1 -n License  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -c '{"args":["initLedger"]}' -v $VERSION











#--------------ch1

CORE_PEER_LOCALMSPID="Org5MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG5_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.example.com/users/Admin@org5.example.com/msp
CORE_PEER_ADDRESS=peer0.org5.example.com:7051   

peer channel join -b $CHANNEL_NAME1.block

peer chaincode install -n fabcompany -v $VERSION -l ${LANGUAGE} -p $TEST_CHAINCODE

#---------------ch2 

CORE_PEER_LOCALMSPID="Org1MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
CORE_PEER_ADDRESS=peer0.org1.example.com:7051

peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME2 -f ./channel-artifacts/channel2.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA 
peer channel join -b $CHANNEL_NAME2.block
peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME2 -f ./channel-artifacts/CH2Org1MSPanchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

peer chaincode install -n fabcompany -v $VERSION -l ${LANGUAGE} -p $TEST_CHAINCODE 
peer chaincode instantiate -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME2 -n fabcompany -l ${LANGUAGE} -v ${VERSION} -c  '{"Args":["initLedger"]}' -P "OR ('Org1MSP.peer')"

CORE_PEER_LOCALMSPID="Org2MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
CORE_PEER_ADDRESS=peer0.org2.example.com:7051
peer channel join -b $CHANNEL_NAME2.block

CORE_PEER_LOCALMSPID="Org3MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
CORE_PEER_ADDRESS=peer0.org3.example.com:7051
peer channel join -b $CHANNEL_NAME2.block

CORE_PEER_LOCALMSPID="Org4MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG4_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp
CORE_PEER_ADDRESS=peer0.org4.example.com:7051    
peer channel join -b $CHANNEL_NAME2.block

CORE_PEER_LOCALMSPID="Org5MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG5_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.example.com/users/Admin@org5.example.com/msp
CORE_PEER_ADDRESS=peer0.org5.example.com:7051 
peer channel join -b $CHANNEL_NAME2.block


#---------------ch3

CORE_PEER_LOCALMSPID="Org2MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
CORE_PEER_ADDRESS=peer0.org2.example.com:7051

peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME3 -f ./channel-artifacts/channel3.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA 
peer channel join -b $CHANNEL_NAME3.block
peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME3 -f ./channel-artifacts/CH3Org2MSPanchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

peer chaincode install -n fabcompany -v $VERSION -l ${LANGUAGE} -p $TEST_CHAINCODE 
peer chaincode instantiate -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME3 -n fabcompany -l ${LANGUAGE} -v ${VERSION} -c  '{"Args":["initLedger"]}' -P "OR ('Org2MSP.peer','Org3MSP.peer')"

CORE_PEER_LOCALMSPID="Org3MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
CORE_PEER_ADDRESS=peer0.org3.example.com:7051
peer channel join -b $CHANNEL_NAME3.block


CORE_PEER_LOCALMSPID="Org5MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG5_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.example.com/users/Admin@org5.example.com/msp
CORE_PEER_ADDRESS=peer0.org5.example.com:7051 
peer channel join -b $CHANNEL_NAME3.block

peer chaincode query -C channel1 -n License -c '{"function":"AllIssue","Args":[]}'

peer chaincode invoke -C channel1 -n License -c '{"function":"addIssue","Args":["3","4","5","6","7"]}' --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -o orderer.example.com:7050 
peer chaincode install -n License -v $VERSION -l ${LANGUAGE} -p $TEST_CHAINCODE 
peer chaincode instantiate -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME1 -n HealthCertificate -l ${LANGUAGE} -v ${VERSION} -c  '{"Args":["initLedger"]}' -P "OR ('Org5MSP.peer','Org5MSP.peer')"

TEST_CHAINCODE="/opt/gopath/src/github.com/chaincode/license/"
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer chaincode invoke -C channel1 -n License -c '{"function":"addIssue","Args":["3","4","5","6","7"]}' --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -o orderer.example.com:7050 

