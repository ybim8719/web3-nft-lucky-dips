// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {AutomationCompatibleInterface} from
    "@chainlink/contracts/src/v0.8/automation/interfaces/AutomationCompatibleInterface.sol";

/**
 * @title TestUpkeep
 * @notice a very basic contract inheriting AutomationCompatibleInterface chainlink.
 * This contract is made for tests on sepolia.
 * Upkeep is registered to try the 2 main functions checkUpkeep and performUpkeep on chain, and to check if parameter "performData" is also passed between the two functions
 * @dev This implements the Chainlink VRF Version 2
 */
contract TestUpkeep is AutomationCompatibleInterface {
    uint256 private constant INTERVAL = 3600;
    uint256 private s_counter = 0;
    uint256 private s_lastTimeStamp;
    uint256 private i_initialTimeStamp;

    constructor() {
        s_lastTimeStamp = block.timestamp;
        i_initialTimeStamp = block.timestamp;
    }

    /**
     * @dev This is the function that the Chainlink Keeper nodes call
     * It's an offchain computation.
     * they look for `upkeepNeeded` to return True.
     */
    function checkUpkeep(bytes memory /* checkData */ )
        public
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        bool timePassed = (block.timestamp - s_lastTimeStamp) > INTERVAL;
        return (timePassed, abi.encode(s_counter));
    }

    /**
     * @dev Once `checkUpkeep` is returning `true`, this function is called
     * and it decodes "performData" and uses it for a state modification.
     */
    function performUpkeep(bytes calldata performData) external override {
        uint256 currentCounter = abi.decode(performData, (uint256));
        s_counter = currentCounter + 1;
        // (bool upkeepNeeded,) = checkUpkeep("");
    }

    function getCounter() public view returns (uint256 counter) {
        return s_counter;
    }

    function getLastTimeStamp() public view returns (uint256 lastTimeStamp) {
        return s_lastTimeStamp;
    }
}
