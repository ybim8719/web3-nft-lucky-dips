-include .env

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
ANVIL_RPC_URL = http://localhost:8545

build:
	forge build

clean:
	forge clean

deploy-anvil:
	forge script script/NFT/DeployNFTBoosterAuctions.s.sol:DeployNFTBoosterAuctions --rpc-url $(ANVIL_RPC_URL=) --private-key $(DEFAULT_ANVIL_KEY) --broadcast -vvvv

feed-anvil:
	forge script script/NFT/Interactions.s.sol:AddAuctions --rpc-url $(ANVIL_RPC_URL=) --private-key $(DEFAULT_ANVIL_KEY) --broadcast -vvvv

deploy-sepolia:
	forge script script/NFT/DeployNFTBoosterAuctions.s.sol:DeployNFTBoosterAuctions --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify -vvvv

feed-sepolia:
	forge script script/NFT/Interactions.s.sol:AddAuctions --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify -vvvv

