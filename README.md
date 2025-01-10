
# ABOUT

This repo is a personal project that I've developed over the course of my solidity apprenticeship, integrating notions I've acquired along the way (chainlink, openzeppelin, ERC721, ERC20, etc...). 

You should therefore consider this project as a sandbox, even though the applications function normally and integrate business logic.  

 **NFTLuckyDip** is an auction market for surprise folders containing a series of NFTs created by artists. The works are revealed only when the auction is completed via the deployment of ERC721-inheriting contracts (called Boosters of NFT, like pokemon stuff).


## Getting Started

1. Clone this repository.
2. Install Forge using the instructions found at [https://github.com/foundry-rs/foundry](https://github.com/foundry-rs/foundry).
3. install npm 
4. Run the following command to compile the contract:

```bash
cd blockchain
forge build
```

Launch the unit tests :
```bash
forge test
```


## NFTLuckyDip (deploy)

### Deployment on Anvil (local blockchain)

1. run Anvil (on a separate terminal): 

```anvil --gas-limit 300000001 ```

Please note that gas limit has been increased to support adding of auctions in Interactions.s.sol.

2. Run the following command to deploy the contract to a test network (<u>the private key given in example is the default account1 created by anvil</u>):

```bash
forge script script/NFT/DeployNFTBoosterAuctions.s.sol --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
```

3. Feed the deployed contract with new auctions :

```bash
forge script script/NFT/Interactions.s.sol --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
```

3. Interact with the contract using cast (few examples) : 

```bash
cast call <PASTE-THE-ADDRESS-OF-CONTRACT> "getBidDuration(uint256 i)" 0

cast call <PASTE-THE-ADDRESS-OF-CONTRACT> "getNextBiddingPriceInWei(uint256 i)" 0

cast send  <PASTE-THE-ADDRESS-OF-CONTRACT> "openAuction(uint256 i)" 0 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

cast send --value 2500000000000000 <PASTE-THE-ADDRESS-OF-CONTRACT> "bidForAuction(uint256 i)" 0 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

### Convert uint with cast (hex to decimal) : 

```bash 
cast --to-base <uint-to-convert> dec
```


### Decode strings with cast abi-decode :

```bash
cast abi-decode "<function-signature> (<return-type>)" <returned-encoded-value>
```

Example : 

```
cast call <PASTE-THE-ADDRESS-OF-CONTRACT> "getName(uint256 i)" 0
```

returns :

```
0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000064a65616e4d690000000000000000000000000000000000000000000000000000
```

decode with :

```
cast abi-decode "getName(uint256 i)(string memory)" 0x0000000000000000000000000000000000000000000000000000
00000000002000000000000000000000000000000000000000000000000000000000000000064a65616e4d690000000000000000000000000000000000000000000000000000
```

result (as string):

```
"JeanMi"
```

## Deployment on Sepolia (testnet)

To deploy to sepolia testnet, add your variable to .env file as described in the .env.example file (the private key of your wallet account with enough ETH faucet and a Sepolia RPC Endpoint) and : 

``` source .env ```

Then launch the unit tests on forked-url:

``` forge test --fork-url $SEPOLIA_RPC_URL```

Then deploy :

```forge script script/DeployTestUpkeep.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --private-key $PRIVATE_KEY ```

And Feed :

```forge script script/Interactions.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --private-key $PRIVATE_KEY ```


## More about contracts purpose

WIP

## More about oracle automation :

NFTBoosterAuctions contract implement Chainlink Automation functions.

This service can be registered here : https://docs.chain.link/chainlink-automation/guides/register-upkeep

And it offers logic-based triggering of upkeep functions which are in charge of 1/ checking if the expiry date of an auction (also called bid) has passed 2/ closing the related auction and handle the process of selling of nft for the buyer. 

A test contract TestUpkeep.sol + script DeployTestUpkeep.s.sol were writen for testing purposes.

Please note that registering to this service will cost Faucet ETH and LINK tokens. 



## Launch front-end 

### WIP

Add Anvil network to metamask : https://ethereum.stackexchange.com/questions/164536/how-can-i-add-anvil-token-from-the-test-token-provided-to-my-metamask-account

Launch React to access client app :
In a separate terminal : 

```bash
cd client
npm install
npm run dev
```

## More about feeding and script of deployment

### WIP

