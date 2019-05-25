#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
export PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}
CHANNEL_NAME=mychannel

# remove previous crypto material and config transactions
rm -fr config/*
rm -fr crypto-config/*

mkdir config
./bin/cryptogen generate --config=./crypto-config.yaml

./bin/configtxgen -profile FiveOrgOrdererGenesis -outputBlock ./config/genesis.block
./bin/configtxgen -profile Channel1_HealthCertificate -outputCreateChannelTx ./config/ch1healthcertificate.tx -channelID healthcertificate
./bin/configtxgen -profile Channel2_LicenseCertificate -outputCreateChannelTx ./config/ch2licensecertificate.tx -channelID licensecertificate
./bin/configtxgen -profile Channel3_AccidentCertificate -outputCreateChannelTx ./config/ch3AccidentCertificate.tx -channelID accidentcertificate

./bin/configtxgen -profile Channel1_HealthCertificate -outputAnchorPeersUpdate ./config/ch1healthcertificateMSPanchors.tx -channelID healthcertificate  -asOrg Org5MSP

./bin/configtxgen -profile Channel2_LicenseCertificate -outputAnchorPeersUpdate ./config/ch2licensecertificateMSPanchors.tx -channelID licensecertificate  -asOrg Org5MSP

./bin/configtxgen -profile Channel3_AccidentCertificate -outputAnchorPeersUpdate ./config/ch3AccidentCertificateMSPanchors.tx -channelID accidentcertificate  -asOrg Org5MSP

 ## generate crypto material
 #cryptogen generate --config=./crypto-config.yaml
 #if [ "$?" -ne 0 ]; then
 #  echo "Failed to generate crypto material..."
 #  exit 1
 #fi
 #
 ## generate genesis block for orderer
 #configtxgen -profile OneOrgOrdererGenesis -outputBlock ./config/genesis.block
 #if [ "$?" -ne 0 ]; then
 #  echo "Failed to generate orderer genesis block..."
 #  exit 1
 #fi
 #
 ## generate channel configuration transaction
 #configtxgen -profile OneOrgChannel -outputCreateChannelTx ./config/channel.tx -channelID $CHANNEL_NAME
 #if [ "$?" -ne 0 ]; then
 #  echo "Failed to generate channel configuration transaction..."
 #  exit 1
 #fi
 #
 ## generate anchor peer transaction
 #configtxgen -profile OneOrgChannel -outputAnchorPeersUpdate ./config/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
 #if [ "$?" -ne 0 ]; then
 #  echo "Failed to generate anchor peer update for Org1MSP..."
 #  exit 1
 #fi
