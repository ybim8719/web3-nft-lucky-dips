// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {TestUpkeep} from "../../src/Upkeep/TestUpKeep.sol";

contract DeployTestUpkeep is Script {
    TestUpkeep private s_testUpkeep;

    function run() external returns (TestUpkeep) {
        vm.startBroadcast();
        s_testUpkeep = new TestUpkeep();
        vm.stopBroadcast();

        return s_testUpkeep;
    }
}
