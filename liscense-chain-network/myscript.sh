CURRENT_DIR=$PWD

cp template-docker-compose.yml docker-compose.yml
OPTS="-i"
cd crypto-config/peerOrganizations/PublisherOrg.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA1_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose.yml

cd crypto-config/peerOrganizations/CheckerOrg.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA2_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose.yml

cd crypto-config/peerOrganizations/RecruiterOrg.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA3_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose.yml

cd crypto-config/peerOrganizations/HealthCheckerOrg.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA4_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose.yml

cd crypto-config/peerOrganizations/PersonOrg.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA5_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose.yml

export MSYS_NO_PATHCONV=1
docker-compose -f docker-compose.yml up -d 

