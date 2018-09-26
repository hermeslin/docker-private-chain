# docker-private-chain
快速建立一個 ethereum 的 private chain

## 如何使用
最簡單的方式就是將 `.env.example` 重新命名為 `.env` 之後，直接在 folder 下執行

```sh
docker-compose up -d
```

## customize your private chain
你可以修改
1. network id
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
docker 的 container stop 後，原本存放的 `.ethereum` 及 `.ethash` 就會一起消失掉，所以可以在 `.env` 內指定

1. BOOTNODE_STORE_FOLDER
2. GETH_STORE_FOLDER
3. MINER_STORE_FOLDER

的位置

### miner 的 account info
如果之前已經有產生好的 account，如果你是按照原本的 folder 產生的話，會存放在 `.ethereum/keystore/` 底下，這樣的話，可以指定 `MINER_STORE_FOLDER` 到你的 folder 位置。
然後在 `.env` 下設定你的 account password ，換掉 `MINER_PWD` 的值就可以，之後在 miner 會自動 unlock account