# docker-private-chain
快速建立一個 ethereum 的 private chain 以及 monitor

![example](https://github.com/hermeslin/docker-private-chain/blob/master/screen-shot.png?001)

## docker 環境
1. alpine:v3.8
2. golang:v1.10
3. go-ethereum:v1.8.16
4. solidity:v0.4.25

## 如何使用

### 產生 .env
先將 `.env.example` 重新命名為 `.env` 之後，build bootnode container
```
docker-compose build bootnode
```

### 產生 static-nodes.json
這是在 `.env` 下的設定
```
GETH_IP=172.16.6.3
GETH_NODE_PORT=30303
GETH_BOOTNODE_KEY=geth.key
```

按照上方的設定執行 bootnode container
```shell
docker-compose run bootnode geth 172.16.6.3 30303
```

會在 ./store/bootnode/ 底下產生 3 個檔案，一個是 `geth.key` 另一個是 `geth.address`，最後一個是 `static-nodes.json`。 `static-nodes.json` 會把當前資料夾底下的 `*.address` 做成 json 檔案

所以再依照 `.env` 下的設定
```
MINER_IP=172.16.6.4
MINER_NODE_PORT=30303
MINER_BOOTNODE_KEY=miner.key
```

執行
```shell
docker-compose run bootnode miner 172.16.6.4 30303
```

最後在 `./store/bootnode/` 會有 5 個檔案， `static-nodes.json` 裡會有 geth 以及 miner 的 enode address。

### 啟動 docker-compose
```shell
docker-compose up -d
```
### Monitor
瀏覽器打開
```
http://localhost:3003
```

## security issue
所有的 container 只有 monitor-view 對 localhost 開放 3003 port（可以從 `.env`）修改，其餘皆在子網路 `172.16.6.0/24` 下
意即 geth 的 rpc port 也只會讓 `172.16.6.0/24` 下的 container 連線

## customize your private chain
你可以修改
1. network id 以及 genesis.json
2. bootnode 的 private key 以及 public key
3. 在本機上存放 miner `.ethereum` 以及 `.ethash` 位置
4. miner 的 account info

### network id
private chain 建立的時候，會依照目前 folder 下的 genesis.json 建立創世區塊，而 `networkid`，會需要在兩個地方設定

1. genesis.json
```json
{
  "config": {
    "chainId": 42,

  ...
  }
}
```

2. .env
```
## private chain id
CHIAN_ID=42
```
這兩個地方的設定需要一致

又或者你有自己已經產生好 `genesis.json`，那就在 `.env` 下
1. 修改 `GENESIS_FILE` 的位置
2. 並把 `CHIAN_ID` 改為你產生好的 `genesis.json` 內的 chainId 數字

### bootnode
如果已經有 bootnode 的 private key 以及 public address 的話
1. 在 `.env` 內換掉 `BOOTNODE_STORE_FOLDER` 的位置，並將你 `bootnode` 的 private key 寫入到 `BOOTNODE_STORE_FOLDER` 底下，做成 `bootnode.key`
2. 將 bootnode 的 public address 寫入 `.env` 的 `BOOTNODE_PUBKEY`

### persistant data
docker 的 container stop 後，原本存放的 `.ethereum` 及 `.ethash` 就會一起消失掉，所以可以在 `.env` 內指定位置

1. BOOTNODE_STORE_FOLDER
2. GETH_STORE_FOLDER
3. MINER_STORE_FOLDER

### miner 的 account info
如果之前已經有產生好的 account，如果你是按照原本的 folder 產生的話，會存放在 `.ethereum/keystore/` 底下，這樣的話，可以指定 `MINER_STORE_FOLDER` 到你的 folder 位置。
然後在 `.env` 下設定你的 account password ，換掉 `MINER_PWD` 的值就可以，之後在 miner 會自動 unlock account