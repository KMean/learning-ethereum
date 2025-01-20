// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title DynamicArrayInMemory
 * @notice This is a contract following Master Solidity: Dynamic Arrays and Memory Layout (https://www.youtube.com/watch?v=mZlqdR8D9vs) from Jesper Kristensen (jtk.eth).
 * @dev Memory in Solidity requires the length of dynamic arrays to be defined, unlike storage, where the index is hashed and its exact position does not matter.
 * In memory, the length is necessary to determine the array's slots and ensure data does not overwrite other memory locations.
 * Memory expansion has a gas cost calculated as:
 * Cost = Cmem * a + a**2 / 512
 * where:
 * -> Cmem is 3 gas per byte
 * -> a is the number of bytes to expand.
 * For example:
 * -> Expanding 32 bytes costs 3 * 32 + 32**2 / 512 = 96 + 32 = 128 gas.
 * -> Expanding 64 bytes costs 3 * 64 + 64**2 / 512 = 192 + 128 = 320 gas.
 * The quadratic nature of the cost makes careful consideration of array length essential to avoid high gas costs or exceeding the block gas limit.
 *
 * Memory Layout:
 * 1. Scratch space (0x00 - 0x3F): Reserved for temporary values during computation.
 * 2. Free memory pointer (0x40): Points to the next available location for memory allocation. It grows upwards as memory is allocated.
 * 3. Zero slot (0x60): Reserved for uninitialized values.
 * 4. Dynamic array allocation:
 *    - Pointer: Stored in memory at the next available location (e.g., slot 2).
 *    - Length: Stored right before the array data (pointer address - 32 bytes).
 *    - Data: Starts immediately after the length.
 */
contract DynamicArraysInMemory {
    /**
     * @dev Demonstrates memory layout and allows probing memory slots.
     * @param length The length of the dynamic memory array to allocate.
     * @param memIndex The index of the memory slot to probe.
     * @return content The content stored in the specified memory slot.
     * @notice If we try to set a huge length, we will get a gas exhaustion error due to memory expansion.
     */
    function probeMemoryLayout(uint256 length, uint256 memIndex) public pure returns (bytes32 content) {
        uint256[] memory a = new uint256[](length);

        a[0] = 2;
        a[a.length - 1] = 4;
        assembly {
            content := mload(mul(memIndex, 0x20))
        }
    }

    /**
     * @dev Demonstrates memory expansion limits and intentional crashing.
     * Attempts to read from an unreasonably large memory slot (slot 130,000),
     * causing a gas exhaustion error due to massive memory expansion.
     * @return content This function will not return as it crashes.
     */
    function memoryCrash() public pure returns (uint256 content) {
        assembly {
            content := mload(mul(130000, 0x20)) // Tries to read from slot 130,000. Will crash the contract.
        }
    }
}
