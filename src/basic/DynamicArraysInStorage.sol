// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title DynamicArrayStorage
 * @notice This is a contract following Master Solidity: Dynamic Arrays and Memory Layout (https://www.youtube.com/watch?v=mZlqdR8D9vs) from Jesper Kristensen (jtk.eth).
 * @dev Demonstrates how Solidity organizes storage for state variables,
 * particularly dynamic arrays.
 */
contract DynamicArraysInStorage {
    uint256 x = 2; // Stored in slot 0
    uint256[] a; // Dynamic array stored in slot 1

    /**
     * @notice Adds a new value to the dynamic array `a`.
     * @param _value The value to be added to the array.
     */
    function pushToArray(uint256 _value) public {
        a.push(_value);
    }

    /**
     * @notice Reads the raw content of a specific storage slot.
     * @param index The storage slot index to read from.
     * @return content The content stored at the specified slot.
     */
    function getStorageSlot(uint256 index) public view returns (uint256 content) {
        assembly {
            content := sload(index)
        }
    }

    /**
     * @notice Computes the keccak256 hash of a given index.
     * @dev Useful for determining the starting slot for dynamic array data.
     * @param index The index for which to calculate the hash.
     * @return hashValue The keccak256 hash of the input index.
     */
    function getHashOfSlot(uint256 index) public pure returns (uint256 hashValue) {
        return uint256(keccak256(abi.encode(index)));
    }
}
