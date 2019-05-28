#!/bin/sh
export PATH=${PWD}/.:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}



sudo rm -Rf ./crypto-config/*
sudo rm -Rf ./channel-artifacts/*

export CHANNEL_NAME1="channel1"
export CHANNEL_NAME2="channel2"
export CHANNEL_NAME3="channel3"

./bin/cryptogen generate --config=./crypto-config.yaml
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi

./bin/configtxgen -profile FiveOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate genesisblock material..."
  exit 1
fi
./bin/configtxgen -profile Channel1 -outputCreateChannelTx ./channel-artifacts/channel1.tx -channelID $CHANNEL_NAME1
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel1.tx material..."
  exit 1
fi
./bin/configtxgen -profile Channel2 -outputCreateChannelTx ./channel-artifacts/channel2.tx -channelID $CHANNEL_NAME2
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel2.tx material..."
  exit 1
fi
./bin/configtxgen -profile Channel3 -outputCreateChannelTx ./channel-artifacts/channel3.tx -channelID $CHANNEL_NAME3
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel3.tx material..."
  exit 1
fi

./bin/configtxgen -profile Channel2 -outputAnchorPeersUpdate ./channel-artifacts/CH2Org1MSPanchors.tx -channelID $CHANNEL_NAME2 -asOrg Org1MSP

./bin/configtxgen -profile Channel2 -outputAnchorPeersUpdate \
./channel-artifacts/CH2Org2MSPanchors.tx -channelID $CHANNEL_NAME2 -asOrg Org2MSP
./bin/configtxgen -profile Channel3 -outputAnchorPeersUpdate \
./channel-artifacts/CH3Org2MSPanchors.tx -channelID $CHANNEL_NAME3 -asOrg Org2MSP

./bin/configtxgen -profile Channel2 -outputAnchorPeersUpdate \
./channel-artifacts/CH2Org3MSPanchors.tx -channelID $CHANNEL_NAME2 -asOrg Org3MSP
./bin/configtxgen -profile Channel3 -outputAnchorPeersUpdate \
./channel-artifacts/CH3Org3MSPanchors.tx -channelID $CHANNEL_NAME3 -asOrg Org3MSP

./bin/configtxgen -profile Channel1 -outputAnchorPeersUpdate \
./channel-artifacts/CH1Org4MSPanchors.tx -channelID $CHANNEL_NAME1 -asOrg Org4MSP
./bin/configtxgen -profile Channel2 -outputAnchorPeersUpdate \
./channel-artifacts/CH2Org4MSPanchors.tx -channelID $CHANNEL_NAME2 -asOrg Org4MSP

./bin/configtxgen -profile Channel1 -outputAnchorPeersUpdate \
./channel-artifacts/CH1Org5MSPanchors.tx -channelID $CHANNEL_NAME1 -asOrg Org5MSP
./bin/configtxgen -profile Channel2 -outputAnchorPeersUpdate \
./channel-artifacts/CH2Org5MSPanchors.tx -channelID $CHANNEL_NAME2 -asOrg Org5MSP
./bin/configtxgen -profile Channel3 -outputAnchorPeersUpdate \
./channel-artifacts/CH3Org5MSPanchors.tx -channelID $CHANNEL_NAME3 -asOrg Org5MSP
