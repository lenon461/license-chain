#!/bin/sh
#export PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:${PWD}/../bin:${PWD}:$PATH
export PATH=${PWD}/.:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}

export CHANNEL_NAME1="channel1"
export CHANNEL_NAME2="channel2"
export CHANNEL_NAME3="channel3"

cp docker-compose-e2e-template.yaml docker-compose-e2e.yaml


# The next steps will replace the template's contents with the
# actual values of the private key file names for the two CAs.
OPTS="-i"
CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/org1.example.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA1_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-e2e.yaml
cd crypto-config/peerOrganizations/org2.example.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA2_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-e2e.yaml
cd crypto-config/peerOrganizations/org3.example.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA3_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-e2e.yaml
cd crypto-config/peerOrganizations/org4.example.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA4_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-e2e.yaml
cd crypto-config/peerOrganizations/org5.example.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA5_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-e2e.yaml



export MSYS_NO_PATHCONV=1
docker-compose -f docker-compose-e2e.yaml up -d

