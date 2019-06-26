./bin/cryptogen generate --config=./crypto-config.yaml
./bin/configtxgen -profile FiveOrgOrdererGenesis -outputBlock genesis.block
./bin/configtxgen -profile Channel1_HealthCertificate -outputCreateChannelTx ch1_healthcertificate.tx -channelID HealthCertificate
./bin/configtxgen -profile Channel2_LicenseCertificate -outputCreateChannelTx ch2_licensecertificate.tx -channelID LicenseCertificate
./bin/configtxgen -profile Channel3_AccidentCertificate -outputCreateChannelTx ch3_AccidentCertificate.tx -channelID AccidentCertificate
configtxgen -profile Channel1_HealthCertificate -outputAnchorPeersUpdate ch1_healthcertificate_MSPanchors.tx -channelID HealthCertificate  -asOrg Org1MSP
