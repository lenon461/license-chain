
CHANNEL_NAME1="channel1"
CHANNEL_NAME2="channel2"
CHANNEL_NAME3="channel3"
CLI_DELAY=3
CLI_TIMEOUT=10
LANGUAGE=node
VERBOSE=true
# docker exec cli scripts/script.sh $CHANNEL_NAME1 $CHANNEL_NAME2 $CHANNEL_NAME3 $CHANNEL_NAME4 $CLI_DELAY $LANGUAGE $CLI_TIMEOUT $VERBOSE
# DELAY="$5"
# LANGUAGE="$6"
# TIMEOUT="$7"
# VERBOSE=true


ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
PEER0_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
PEER0_ORG2_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
PEER0_ORG3_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
PEER0_ORG4_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt
PEER0_ORG5_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.example.com/peers/peer0.org5.example.com/tls/ca.crt



CORE_PEER_LOCALMSPID="Org1MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
CORE_PEER_ADDRESS=peer0.org1.example.com:7051

CORE_PEER_LOCALMSPID="Org2MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
CORE_PEER_ADDRESS=peer0.org2.example.com:7051

CORE_PEER_LOCALMSPID="Org3MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
CORE_PEER_ADDRESS=peer0.org3.example.com:7051

CORE_PEER_LOCALMSPID="Org4MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG4_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp
CORE_PEER_ADDRESS=peer0.org4.example.com:7051 

CORE_PEER_LOCALMSPID="Org5MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG5_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org5.example.com/users/Admin@org5.example.com/msp
CORE_PEER_ADDRESS=peer0.org5.example.com:7051                                         


peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME1 -f ./channel-artifacts/channel1.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA 
peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME2 -f ./channel-artifacts/channel2.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME3 -f ./channel-artifacts/channel3.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA 

peer channel join -b $CHANNEL_NAME1.block


CC_SRC_PATH3="/opt/gopath/src/github.com/chaincode/channel3/"
CC_SRC_PATH2="/opt/gopath/src/github.com/chaincode/channel2/"
CC_SRC_PATH1="/opt/gopath/src/github.com/chaincode/channel1/"
VERSION=1.0
LANGUAGE=node


peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME1 -f ./channel-artifacts/CH1Org5MSPanchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME1 -f ./channel-artifacts/CH2Org5MSPanchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME1 -f ./channel-artifacts/CH3Org5MSPanchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA  
peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME1 -f ./channel-artifacts/CH1Org4MSPanchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

peer chaincode install -n channel1 -v $VERSION -l ${LANGUAGE} -p $CC_SRC_PATH1 
peer chaincode install -n channel2 -v $VERSION -l ${LANGUAGE} -p $CC_SRC_PATH2 
peer chaincode install -n channel3 -v $VERSION -l ${LANGUAGE} -p $CC_SRC_PATH3

peer chaincode install -n channel2 -v $VERSION -l golang -p $CC_SRC_PATH2 

peer chaincode instantiate -o orderer.example.com:7050 -C $CHANNEL_NAME1 -n channel1 -l ${LANGUAGE} -v ${VERSION} -c '{"Args":[]}' -P "AND ('Org4MSP.peer','Org5MSP.peer')"
peer chaincode instantiate -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME1 -n channel1 -l ${LANGUAGE} -v ${VERSION} -c  '{"Args":[""]}' -P "OR ('Org4MSP.peer','Org5MSP.peer')"
peer chaincode instantiate -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME1 -n channel1 -l ${LANGUAGE} -v ${VERSION} -c  '{"Args":[""]}' -P "OR ('Org5MSP.peer')"


peer chaincode install -n fabcompany -v $VERSION -l ${LANGUAGE} -p /opt/gopath/src/github.com/chaincode/javascript
peer chaincode instantiate -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME1 -n fabcompany -l ${LANGUAGE} -v ${VERSION} -c  '{"Args":[""]}' -P "OR ('Org4MSP.peer','Org5MSP.peer')"

