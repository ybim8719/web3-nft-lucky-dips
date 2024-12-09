
# ABOUT

This repo is a personal project that I've developed over the course of my solidity apprenticeship, integrating notions I've acquired along the way (chainlink, openzeppelin, ERC721, ERC20, etc...). 

You should therefore consider this project as a sandbox, even though the applications function normally and integrate business logic.  

 **NFTLuckyDip** is an auction market for surprise folders containing a series of NFTs created by artists. The works are revealed only when the auction is completed via the deployment of an ERC 721 contract.


## Getting Started

1. Clone this repository.
2. Install Forge using the instructions found at [https://github.com/foundry-rs/foundry](https://github.com/foundry-rs/foundry).
3. install npm 


4. Run the following command to compile the contract:

```bash
cd foundry
forge build
```

5. Launch the unit tests :

```bash
forge test
```


## NFTLuckyDip (deploy)

### Deployment on Anvil 

1. run Anvil (on a separate terminal): 

```bash 
make anvil
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



### More about feeding 




## BulkDealFactory (deploy)

1. test :

```bash
forge test
```

1. Run the following command to deploy the contract to a test network:

```bash
forge create
```

2. Interact with the contract using Forge's interactive console.

```bash
forge console
```



## More about tests and deployments

TODO : 
