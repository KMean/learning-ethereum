// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {DeployDynamicArraysInMemory} from "script/DeployDynamicArraysInMemory.s.sol";
import {DynamicArraysInMemory} from "src/memory/DynamicArraysInMemory.sol";

contract DynamicArraysInMemoryTest is Test {
    DynamicArraysInMemory public dynamicArraysInMemory;

    function setUp() public {
        // Use the deploy script to deploy the contract and get the instance
        DeployDynamicArraysInMemory deployScript = new DeployDynamicArraysInMemory();
        dynamicArraysInMemory = deployScript.run();
    }

    function testProbeMemoryLayout() public view {
        uint256 length = 2;

        // Scratch space validation
        assertEq(
            dynamicArraysInMemory.probeMemoryLayout(length, 0),
            bytes32(0),
            "Slot 0 (scratch space) should be empty initially"
        );
        assertEq(
            dynamicArraysInMemory.probeMemoryLayout(length, 1),
            bytes32(0),
            "Slot 1 (scratch space) should be empty initially"
        );

        // Slot 2: Pointer to the start of the array data
        bytes32 slot2 = dynamicArraysInMemory.probeMemoryLayout(length, 2);
        uint256 expectedArrayStart = 0xe0; // Pointer to the array data
        assertEq(slot2, bytes32(expectedArrayStart), "Slot 2 should point to the start of the array data");

        // Slot 3: Zero slot
        bytes32 zeroSlot = dynamicArraysInMemory.probeMemoryLayout(length, 3);
        assertEq(zeroSlot, bytes32(0), "Slot 3 should remain unused and be zero");

        // Slot 4: Array length
        bytes32 lengthSlot = dynamicArraysInMemory.probeMemoryLayout(length, 4);
        assertEq(lengthSlot, bytes32(uint256(length)), "Slot 4 should contain the array length");

        // Slot 5: First value of the array
        bytes32 firstValue = dynamicArraysInMemory.probeMemoryLayout(length, 5);
        assertEq(firstValue, bytes32(uint256(2)), "Slot 5 should contain the first value of the array");

        // Slot 6: Last value of the array
        bytes32 lastValue = dynamicArraysInMemory.probeMemoryLayout(length, 6);
        assertEq(lastValue, bytes32(uint256(4)), "Slot 6 should contain the last value of the array");
    }

    function testMemoryCrash() public {
        // Expect the function to revert due to Memory Out of Gas
        vm.expectRevert(); // General revert expectation

        // Limit the gas to simulate out-of-gas behavior
        vm.prank(address(this)); // Set the caller
        dynamicArraysInMemory.memoryCrash{gas: 1000000}(); // Provide limited gas
    }

    function testProbeMemoryLayoutLargeArray() public view {
        uint256 length = 100; // Large but reasonable array size

        // Slot 2: Pointer to the start of the array data
        bytes32 slot2 = dynamicArraysInMemory.probeMemoryLayout(length, 2);
        uint256 expectedArrayStart = 0xd20; // Pointer to the array data
        assertEq(slot2, bytes32(expectedArrayStart), "Slot 2 should point to the start of the array data");
    }
}
