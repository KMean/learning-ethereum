// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/Test.sol";
import {DynamicArraysInMemory} from "src/memory/DynamicArraysInMemory.sol";

contract DeployDynamicArraysInMemory is Script {
    function run() external returns (DynamicArraysInMemory) {
        vm.startBroadcast();

        // Deploy the contract
        DynamicArraysInMemory dynamicArraysInMemory = new DynamicArraysInMemory();

        // Log the deployed contract address
        console2.log("DynamicArray deployed at:", address(dynamicArraysInMemory));

        vm.stopBroadcast();

        // Return the deployed contract instance
        return dynamicArraysInMemory;
    }
}
