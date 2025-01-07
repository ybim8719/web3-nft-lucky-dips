
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

5. Launch the unit tests :
```bash
forge test
```


## NFTLuckyDip (deploy)

### Deployment on Anvil (local blockchain)

1. run Anvil (on a separate terminal): 

```bash 
anvil
``` 

2. Run the following command to deploy the contract to a test network:

```bash
forge script ..... 
```

3. Interact with the contract using Cast.

```bash
forge console
```

4. Add Anvil network to metamask 

5. Launch React to access client app :

In a separate terminal : 

```bash
cd client
npm install
npm run dev
```

## Deployment on Sepolia (testnet)

```forge script script/DeployTestUpkeep.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --private-key $PRIVATE_KEY```

=>

``` source .env ```

Some faucet ETH are needed for  

## More about oracle automation :

NFTBoosterAuctions contract implement Chainlink Automation functions.

This service can be registered here : https://docs.chain.link/chainlink-automation/guides/register-upkeep

And it offers logic-based triggering of upkeep functions which are in charge of 1/ checking if the expiry date of an auction (also called bid) has passed 2/ closing the related auction and handle the process of selling of nft for the buyer. 

A test contract TestUpkeep.sol + script DeployTestUpkeep.s.sol were writen for testing purposes.

Please note that registering to this service will cost Faucet ETH and LINK tokens. 



## Launch front-end 

WIP


## More about feeding 

WIP

