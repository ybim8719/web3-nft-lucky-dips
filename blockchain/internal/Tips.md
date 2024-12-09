# List of useful commands for foundry

## Create a new project : 

```
forge init <name-of-project>
```

## Anvil
Anvil local endpoint : http://127.0.0.1:7545

Anvil tests private keys list : 

(0)0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
(1)0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d


### Basic Deployment on Anvil :

(anvil must be active on another terminal)

Basic command on a given contract => fake deployment

```
forge create <contract-name> --rpc-url http://127.0.0.1:7545
```

To add a private key, 2 ways : 

1) A prompt will appear to ask the private key input:

```
forge create <contract-name> --rpc-url http://127.0.0.1:7545 --interactive
```

2) on-command method (bad):

```
forge create <contract-name> --rpc-url http://127.0.0.1:8545 --private-key <anvil-private-key>
```

### Simulate/Deploy a contract with a script: 

On Anvil with storage data on .env: 

```
forge script script/<script-name>.s.sol --rpc-url $RPC_URL --broadcast --private-key $PRIVATE_KEY
```
if you remove the flag `--broadcast`, a simple simulation will be made instead of deployment.

### A great way to secure your private key using cast : 

```
cast wallet import <nameOfAccountGoesHere> --interactive
```
You will be asked for your private key and a password to secure it. You will do this only once.

an address will be showned. Save it for next step : 

```
forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --account <nameOfAccountGoesHere> --sender <address-retrieved-on-prevstep>
```

List of accounts created here : 

```
cast wallet list
```

### Use cast to interact with deployed contract : 

1) Send a transaction : 

```
cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "store(uint256)" 1337 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

* `0x5FbDB2315678afecb367f032d93F642f64180aa3` or any other address is the target of our `cast send`, the contract we are interacting with;

* `"store(uint256)"` is the [signature of the function](https://ethereum.stackexchange.com/questions/135205/what-is-a-function-signature-and-function-selector-in-solidity-and-evm-language) we are calling.

* `1337` is the number we pass to the `store` function. As we can see in the function signature, we are expected to provide an `uint256` input. You can obviously provide any number you want, as long as it fits `uint256`.

2) Reading from contract :

```
cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "retrieve()"
```

## Use cast to convert hexadecimal to decimal :

```
cast --to-base 0x0000000000000000000000000000000000000000000000000000000000000539 dec
```

## Install chainlist as a dependency

```
forge install smartcontractkit/chainlink-brownie-contracts@1.2.0 --no-commit
```

version to be found here : https://github.com/smartcontractkit/chainlink-brownie-contracts
current version is 1.2.0 


in toml for imports : 
remappings = ['@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/']

## Tests

Basic command : 

```
forge test -vvv
```

```
forge test --mt <name-of-test-function>
forge coverage --fork-url $SEPOLIA_RPC_URL
forge test --mt <name-of-test-function> --fork-url $SEPOLIA_RPC_URL
```


## CheatCodes

example of code used to create random users and hoax them

```
uint160 numberOfFunders = 10;
uint160 startingFunderIndex = 1;
for (uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++) {
    // we get hoax from stdcheats
    // prank + deal
    hoax(address(i), SEND_VALUE);
    contract.doSomething{value: SEND_VALUE}();
}
``` 

### Example of prank:

```
vm.startPrank(contract.getOwner());
contract.doSomething();
vm.stopPrank();
```

1\. You see that both these variables are defined as `uint160` and not our usual `uint256`. Down the road, we will use the `startingFunderIndex` as an address. If we look at the definition of an we see that it holds `a 20 byte value` and that `explicit conversions to and from address are allowed for uint160, integer literals, bytes20 and contract types`.

```
`forge snapshot --mt <name-of-test-function-to-estimate>`
```

You'll see that a new file appeared in your project root folder: `.gas-snapshot`.


Estimate consumption of gas with vm :

``` 
vm.txGasPrice(GAS_PRICE);
uint256 gasStart = gasleft();

// Act
vm.startPrank(contract.getOwner());
contract.withdraw();
vm.stopPrank();

uint256 gasEnd = gasleft();
uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
console.log("Withdraw consumed: %d gas", gasUsed);
``` 


## Makefile :

The `.PHONY:` tells make that all the `all test clean deploy fund help install snapshot format anvil` are not folders. Following that we declare the `DEFAULT_ANIVL_KEY` and a custom help message.

``` 
`make anvil`

`make deploy`

`make deploy ARGS="--network sepolia"`.

``` 

``` 
forge remappings>remappings.txt
``` 

Reset an array of payable address 

 ``` 
 s_players = new address payable[](0);
 ``` 

/*//////////////////////////////////////////////////////////////
                           ENTER RAFFLE
//////////////////////////////////////////////////////////////*/

## change timestamp

 ``` 
vm.warp(block.timestamp + interval + 1);

 ``` 
 
## change block number 

 ``` 
vm.roll(block.number + 1);
 ``` 
* [vm.warp](https://book.getfoundry.sh/cheatcodes/warp?highlight=warp#warp) which sets the `block.timestamp`;
* [vm.roll](https://book.getfoundry.sh/cheatcodes/roll?highlight=roll#roll) which sets the `block.number`;
* [vm.warp](https://book.getfoundry.sh/cheatcodes/warp?highlight=warp#warp) which sets the `block.timestamp`;
* [vm.roll](https://book.getfoundry.sh/cheatcodes/roll?highlight=roll#roll) which sets the `block.number`;

forge install transmissions11/solmate --no-commit

`forge install Cyfrin/foundry-devops --no-commit`

`import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";`


The following command will create a file called `coverage.txt`, containing the specific lines of code that have not been covered yet.

```bash
forge coverage --report debug > coverage.txt
```

forge coverage --report debug > coverage.txt

 
 hyper detailled test 

`forge test --debug testRaffleRecordsPlayerWhenTheyEnter`.


## NFT 

cmd svg to base64 

base64 -i example.svg

data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MDAiIGhlaWdodD0iNTAwIj4KPHRleHQgeD0iMjAwIiB5PSIyNTAiIGZpbGw9IndoaXRlIj5IaSEgWW91IGRlY29kZWQgdGhpcyEgPC90ZXh0Pgo8L3N2Zz4=



### string comparison :


assert(keccak256(abi.encodePacked(moodNft.symbol())) == keccak256(abi.encodePacked((NFT_SYMBOL))));


## Fuzz testing 

### StateLess test

[fuzz]
runs = 1000

```
function testIAlwaysGetZero(uint256 data) public {
    myContract.doStuff(data);
    assert(myContract.shouldAlwaysBeZero() == 0);
}
``` 


Exemple : 

### Statefull test

(test randomly triggers functions with random data in a given contract) 

```
import {CaughtWithTest} from "src/MyContract.sol";
import {console, Test} from "forge-std/Test.sol";
import{StdInvariant} from "forge-std/StdInvariant.sol";

contract MyContractTest is StdInvariant, Test {
    CaughtWithTest myContract;

    function setUp() public {
        myContract = new CaughtWithTest();
        targetContract(address(myContract));
    }

    function invariant_testAlwaysReturnsZero() public view {
        assert(truc == 0);
    }
}
```
step invariant tests params in foundry.toml

```
[invariant]
runs = 128
depth = 128
fail_on_revert = false
```

### get max number on int type
uint256 MAX_DEPOSIT_SIZE = type(uint96).max;