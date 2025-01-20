// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import {DynamicArraysInStorage} from "../src/storage/DynamicArraysInStorage.sol";

contract DeployDynamicArraysInStorage is Script {
    function run() external returns (DynamicArraysInStorage) {
        vm.startBroadcast(); // Begin broadcasting transactions

        // Deploy the contract
        DynamicArraysInStorage dynamicArraysInStorage = new DynamicArraysInStorage();

        // Log the deployed contract address
        console.log("DynamicArrayStorage deployed at:", address(dynamicArraysInStorage));

        vm.stopBroadcast(); // End broadcasting

        // Return the deployed contract instance
        return dynamicArraysInStorage;
    }
}
