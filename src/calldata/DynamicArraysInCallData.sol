// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title CalldataBehavior
 * @notice Demonstrates calldata layout, access, and its efficient usage in Solidity.
 * @dev Explores how calldata is passed to functions and accessed directly using assembly.
 */
contract CalldataBehavior {
    /**
     * @notice Decodes a dynamic array of uint256 from calldata.
     * @param data The calldata containing the encoded array.
     * @return decodedArray The decoded dynamic array.
     */
    function decodeDynamicArray(bytes calldata data) external pure returns (uint256[] memory decodedArray) {
        // Decoding the array using abi.decode
        decodedArray = abi.decode(data, (uint256[]));
    }

    /**
     * @notice Reads raw calldata using assembly.
     * @param offset The byte offset in calldata to start reading from.
     * @return value The 32-byte value at the specified offset.
     */
    function readCalldata(uint256 offset) external pure returns (bytes32 value) {
        assembly {
            value := calldataload(offset)
        }
    }

    /**
     * @notice Copies raw calldata to memory using assembly.
     * @param start The starting byte offset in calldata.
     * @param length The number of bytes to copy.
     * @return copiedData The copied calldata as a bytes array.
     */
    function copyCalldata(uint256 start, uint256 length) external pure returns (bytes memory copiedData) {
        copiedData = new bytes(length);
        assembly {
            let dataPtr := add(copiedData, 0x20) // Skip the length slot
            calldatacopy(dataPtr, start, length)
        }
    }
}
