// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {DeployDynamicArraysInStorage} from "script/DeployDynamicArraysInStorage.s.sol";
import {DynamicArraysInStorage} from "src/basic/DynamicArraysInStorage.sol";

contract DynamicArraysInStorageTest is Test {
    DynamicArraysInStorage public dynamicArraysInStorage;

    function setUp() public {
        // Use the deploy script to deploy the contract
        DeployDynamicArraysInStorage deployScript = new DeployDynamicArraysInStorage();
        dynamicArraysInStorage = deployScript.run();
    }

    function testInitialSlots() public view {
        // Slot 0: x = 2
        uint256 slot0 = dynamicArraysInStorage.getStorageSlot(0);
        assertEq(slot0, 2, "Slot 0 should contain the value of x");

        // Slot 1: Array length = 0
        uint256 slot1 = dynamicArraysInStorage.getStorageSlot(1);
        assertEq(slot1, 0, "Slot 1 should contain the length of the array");
    }

    function testPushAndVerifyStorage() public {
        // Push values into the array
        dynamicArraysInStorage.pushToArray(42);
        dynamicArraysInStorage.pushToArray(99);

        // Slot 1: Array length = 2
        uint256 slot1 = dynamicArraysInStorage.getStorageSlot(1);
        assertEq(slot1, 2, "Slot 1 should contain the updated length of the array");

        // Calculate storage location for array data
        uint256 arrayDataSlot = dynamicArraysInStorage.getHashOfSlot(1);

        // Verify first value
        uint256 firstValue = dynamicArraysInStorage.getStorageSlot(arrayDataSlot);
        assertEq(firstValue, 42, "First array element should be 42");

        // Verify second value
        uint256 secondValue = dynamicArraysInStorage.getStorageSlot(arrayDataSlot + 1);
        assertEq(secondValue, 99, "Second array element should be 99");
    }

    function testHashOfSlot() public view {
        // Verify that the calculated hash matches expected values
        uint256 arrayDataSlot = dynamicArraysInStorage.getHashOfSlot(1);
        uint256 expectedHash = uint256(keccak256(abi.encode(1)));
        assertEq(arrayDataSlot, expectedHash, "Hash of slot 1 should match expected keccak256 hash");
    }
}
