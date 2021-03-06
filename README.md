# hyperledger
## Hyperledger Fabric Multienv

## HLF 분산환경

### 0. 구동 환경
##### - Client(User) :CentOS7 — cli
##### - Org0 (include 2 Peer) : CentOS7, 1 CPU, 2 RAM, 30GB
   container > org0.peer0, org0.peer1, couchDB00, couchDB01, cli0
##### - Org1 (include 2 Peer) : CentOS7, 1 CPU, 2 RAM, 30GB
   container > org1.peer0, org1.peer1, couchDB10, couchDB11, cli1

##### - Orderer1 : CentOS7, 1 CPU, 2 RAM, 40GB 
   container > orderer1, kafka0, zookeeper1, ca0, ca1 
##### - Orderer2 : CentOS7, 1 CPU, 2 RAM, 40GB 
   container > orderer2, kafka1, zookeeper2
##### - Orderer3 : CentOS7, 1 CPU, 2 RAM, 40GB 
   container > orderer3, kafka2, kafka3,  zookeeper3

1. 사용툴 링크
<pre><code>
$ sudo ln -s /home/jongseek98/fabric-samples/bin/cryptogen /usr/bin/cryptogen
$ sudo ln -s /home/jongseek98/fabric-samples/bin/configtxgen /usr/bin/configtxgen
$ sudo ln -s /home/jongseek98/fabric-samples/bin/configtxlator /usr/bin/configtxlator
$ sudo ln -s /home/jongseek98/fabric-samples/bin/discover /usr/bin/discover
$ sudo ln -s /home/jongseek98/fabric-samples/bin/fabric-ca-client /usr/bin/fabric-ca-client
$ sudo ln -s /home/jongseek98/fabric-samples/bin/idemixgen /usr/bin/idemixgen
$ sudo ln -s /home/jongseek98/fabric-samples/bin/orderer /usr/bin/orderer
</code></pre>

2. crypto-config, configtxgen
<pre><code>
$ vi crypto-config.yaml
$ cryptogen generate --config=./crypto-config.yaml
$ vi configtx.yaml
$ export FABRIC_CFG_PATH=[Directory for containing configtx.yaml]
$ configtxgen -profile TwoOrgsOrdererGenesis -outputBlock genesis.block
$ configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ch1.tx -channelID ch1
$ configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate Org0MSPanchors.tx -channelID ch1 -asOrg Org0MSP
$ configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate Org1MSPanchors.tx -channelID ch1 -asOrg Org1MSP
$ mkdir channel-artifact
$ mv ch1.tx genesis.block Org0MSPanchors.tx Org1MSPanchors.tx channel-artifact
$ tar cvf channel-artifact.tar channel-artifact
(Each EC)$ git pull ~~
(Each EC)$ ./init_channel_artifact.sh

$ gcloud compute scp multienv orderer1:/home/jongseek98/multienv (scp -rq directory User@host:Directory) -> gap 끼리 파일 공유 해결 못함. 결국 git 씀…
($ git clone http://github. com/Hobby0113/Hyperledger.git)
</code></pre>

3. create docker swarm network
<pre><code>
(Leader EC)$ docker swarm init
(Leader EC)$ docker swarm join-token manager
(Each EC)$ docker swarm join --token SWMTKN-1-66sgj9z2tllbig1kjpgs85mjd2rqpbho4ncr0qmkpohs2ko4ga-5la1dufa8azq8ut7yghdx2sxz 10.148.0.11:2377
$ docker node ls # swarm node checck
(Leader EC)$ docker network create --attachable --driver overlay hlf
$ docker network ls # network check -> ukje5bdwu3zp  hlf  overlay  swarm
(Each EC)$ git clone http://github. com/Hobby0113/Hyperledger.git
(Leader EC)$ docker stack deploy --compose-file docker-compose-zookeeper.yaml hlf
(Leader EC)$ docker stack deploy --compose-file docker-compose-kafka.yaml hlf
(Leader EC)$ docker stack deploy --compose-file docker-compose-orderer.yaml hlf
(Leader EC)$ docker stack deploy --compose-file docker-compose-ca.yaml hlf
(Leader EC)$ docker stack deploy --compose-file docker-compose-couchdb.yaml hlf
(Leader EC)$ docker stack deploy --compose-file docker-compose-org.yaml hlf
(Each EC)$ docker ps
</pre></code>

3-1. initialize docker swarm network
<pre><code>
sudo service docker stop
sudo rm -rf /var/lib/docker/swarm
sudo service docker start
(Reachable EC) docker swarm leave --force
(Leader EC) docker node demote NODE
(Leader EC) docker node rm NODE
docker service ps --no-trunc {SERVICE NAME}
docker service ps --no-trunc {SERVICE NAME} --format "{{.Name}}: {{.Error}}"
docker service rm $(docker service ls -q)
</code></pre>

4. Create and join
<pre><code>
(org0)$ docker exec -e "CORE_PEER_LOCALMSPID=Org0MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org0/msp" {containerNAME} peer channel create -o orderer1:7050 -c ch1 -f /etc/hyperledger/fabric/channel-artifacts/ch1.tx --tls --cafile /etc/hyperledger/orderers/orderer0.orderer/msp/tlscacerts/tlsca.orderer-cert.pem

../crypto-config/ordererOrganizations/orderer/orderers/:/etc/hyperledger/orderers

(org0)$ docker exec -e "CORE_PEER_LOCALMSPID=Org0MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org0/msp" {containerNAME} peer channel join -b genesis.block
</code></pre>














