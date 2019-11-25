# hyperledger
Hyperledger Fabric Multienv

HLF 분산환경

0. 구동 환경
- Client(User) :CentOS7 — cli
- Org0 (include 2 Peer) : CentOS7, 1 CPU, 2 RAM, 30GB — peer0, peer1, cli0
- Org1 (include 2 Peer) : CentOS7, 1 CPU, 2 RAM, 30GB — peer2, peer3, cli1
- Orderer1 : CentOS7, 1 CPU, 2 RAM, 40GB — orderer1, kafka-zookeeper1, ca0, ca1 
- Orderer2 : CentOS7, 1 CPU, 2 RAM, 40GB — orderer2, kafka-zookeeper2,
- Orderer3 : CentOS7, 1 CPU, 2 RAM, 40GB — orderer3, kafka-zookeepre3,

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
$ mv genesis.block ~/multienv/crypto-config/ordererOrganizations/ordererorg1/orderers/orderer1.ordererorg1/
$ mv genesis.block ~/multienv/crypto-config/ordererOrganizations/ordererorg2/orderers/orderer2.ordererorg2/
$ mv genesis.block ~/multienv/crypto-config/ordererOrganizations/ordererorg3/orderers/orderer3.ordererorg3/
$ configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ch1.tx -channelID ch1
$ configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate Org0MSPanchors.tx -channelID ch1 -asOrg Org0MSP
$ configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate Org1MSPanchors.tx -channelID ch1 -asOrg Org1MSP
$ gcloud compute scp multienv orderer1:/home/jongseek98/multienv (scp -rq directory User@host:Directory) -> gap 끼리 파일 공유 해결 못함. 결국 git 씀…
($ git clone http://github. com/Hobby0113/Hyperledger.git)
</code></pre>

3. create docker swarm network
<pre><code>
(Leader VM)$ docker swarm init
(Leader VM)$ docker swarm join-token manager
(Each VM)$ docker swarm join --token SWMTKN-1-66sgj9z2tllbig1kjpgs85mjd2rqpbho4ncr0qmkpohs2ko4ga-5la1dufa8azq8ut7yghdx2sxz 10.148.0.11:2377
$ docker node ls # swarm node check
(Leader VM)$ docker network create --attachable --driver overlay hlf
$ docker network ls # network check -> ukje5bdwu3zp  hlf  overlay  swarm
(Each VM)$ git clone http://github. com/Hobby0113/Hyperledger.git
(Leader VM)$ docker stack deploy --compose-file docker-compose-mq.yaml fabric
(Leader VM)$ docker stack deploy --compose-file docker-compose.yaml fabric   
</pre></code>




