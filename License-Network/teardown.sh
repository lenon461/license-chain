set -e

# Shut down the Docker containers for the system tests.
docker-compose -f docker-compose-e2e.yaml kill && docker-compose -f docker-compose-e2e.yaml down

# remove the local state
#rm -f ~/.hfc-key-store/*

# remove chaincode docker images
docker rm $(docker ps -aq)
docker rmi $(docker images dev-* -q)

# Your system is now clean

