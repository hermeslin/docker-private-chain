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

## 開發環境
這是使用 truffle 以及 ganache-cli 來做 locale 端的開發，先確定在 ganache-cli 上開發及 test 無誤後，未來在 [truffle.js](https://github.com/hermeslin/Splitter/blob/master/truffle.js) 內加上這個 private chain 的 network，就可以再 deploy 到 private chain 上

### 版本
1. Truffle v4.1.14 (core: 4.1.14)
2. Solidity v0.4.24 (solc-js)
3. Ganache CLI v6.1.7 (ganache-core: 2.2.1)

### 使用方式
啟動 ganache-cli
```shell
docker-compose up -d ganache-cli
```

查看 ganache-cli log，可以查看 smart contract deploy 後的狀況
```shell
docker-compose logs -f ganache-cli
```

### truffle
進入 truffle，並 init 一個新的 project，可以在 `.env` 的 `TRUFFLE_STORE_FOLDER` 設定要 mount 進 `truffle` 的資料夾位置
```shell
> docker-compose run truffle /bin/ash
/ #
> cd /root/truffle && mkdir hello_world && cd hello_world
~/truffle/hello_world #
>truffle init
Downloading...
Unpacking...
Setting up...
Unbox successful. Sweet!

Commands:

  Compile:        truffle compile
  Migrate:        truffle migrate
  Test contracts: truffle test
```

修改 `/root/truffle/hello_world/truffle.js`，並指定 `development` 的位置，port 以及 network_id 會是 `.env` 內的 `GANACHE_CLI_PORT` 以及 `GANACHE_CLI_NETWORK_ID`
```javascript
module.exports = {
  networks: {
    development: {
      host: "ganache-cli",
      port: 6666,
      network_id: "6666"
    }
  }
};
```

### 測試 ganache-cli 的 RPC 是否可用
可以在進入 truffle 後，用 curl 去測試，但是這個 image 內沒有裝 curl，可以先裝 curl
```shell
> apk add curl
```

用 curl 測試 ganache-cli 的 RPC
``` shell
curl -H "Content-Type: application/json" -X POST --data '{"id": "1", "jsonrpc":"2.0","method":"net_version","params":[]}' http://ganache-cli:6666
```