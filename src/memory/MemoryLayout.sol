// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/**
 * @title Memory Layout and Assembly Operations in Solidity
 * @notice This contract demonstrates how memory works in Solidity using inline assembly.
 * @dev Covers basic memory operations, struct handling, fixed/dynamic arrays, ABI encoding, and more.
 */

// Solidity Memory Layout:
// - Memory is a contiguous array where each slot is 32 bytes.
// - Reserved memory slots:
//   - 0x00 - 0x3f (64 bytes): Scratch space for hashing (keccak256, etc.).
//   - 0x40 - 0x5f (32 bytes): Free memory pointer (points to next available memory address).
//   - 0x60 - 0x7f (32 bytes): Zero slot (used for dynamic arrays and should never be written to).

// Memory starts at 0x80 (free memory pointer initially points here).

contract MemBasic {
    /**
     * @notice Demonstrates storing and loading values in memory.
     * @return b32 The stored 32-byte value retrieved from memory.
     */
    function test_1() public pure returns (bytes32 b32) {
        assembly {
            let p := mload(0x40) // Load free memory pointer (initially 0x80)
            mstore(p, 0xababab) // Store value at memory location p
            b32 := mload(p) // Load stored value back
        }
    }

    /**
     * @notice Demonstrates how memory addresses are structured by writing values at specific locations.
     */
    function test_2() public pure {
        assembly {
            mstore(0, 0x11) // Store 0x11 at index 0x00
            mstore(1, 0x22) // Store 0x22 at index 0x01 (misaligned)
            mstore(2, 0x33) // Store 0x33 at index 0x02 (misaligned)
            mstore(3, 0x44) // Store 0x44 at index 0x03 (misaligned)
        }
    }
}

contract MemStruct {
    /**
     * @notice Demonstrates how structs are stored in memory.
     * Struct data is not tightly packed in memory.
     */
    struct Point {
        uint256 x; // Stored at 0x80
        uint32 y; // Stored at 0xa0
        uint32 z; // Stored at 0xc0
    }

    /**
     * @notice Reads a struct from memory using assembly.
     */
    function test_read() public pure returns (uint256 x, uint256 y, uint256 z) {
        Point memory p = Point(1, 2, 3);
        assembly {
            x := mload(0x80) // Load uint256 x
            y := mload(0xa0) // Load uint32 y
            z := mload(0xc0) // Load uint32 z
        }
    }
}

contract MemDynamicArray {
    /**
     * @notice Reads a dynamically allocated array from memory.
     */
    function test_read() public pure returns (bytes32 p, uint256 len, uint256 a0, uint256 a1, uint256 a2) {
        uint256[] memory arr = new uint256[](5);
        arr[0] = 11;
        arr[1] = 22;
        arr[2] = 33;
        arr[3] = 44;
        arr[4] = 55;

        assembly {
            p := arr
            len := mload(arr) // Load array length
            a0 := mload(add(arr, 0x20)) // Load first element
            a1 := mload(add(arr, 0x40)) // Load second element
            a2 := mload(add(arr, 0x60)) // Load third element
        }
    }
}

contract MemKeccak {
    /**
     * @notice Computes the Keccak-256 hash of stored values in memory.
     */
    function test_keccak() public pure returns (bytes32) {
        assembly {
            mstore(0x80, 1) // Store value at 0x80
            mstore(0xa0, 2) // Store value at 0xa0
            let h := keccak256(0x80, 0x40) // Hash the data range 0x80 - 0xbf
            mstore(0xc0, h) // Store hash result
            return(0xc0, 0x20) // Return the hash value
        }
    }
}

contract ABIEncode {
    /**
     * @notice Encodes an address in ABI format.
     */
    function encode_addr() public pure returns (bytes memory) {
        address addr = 0xABaBaBaBABabABabAbAbABAbABabababaBaBABaB;
        return abi.encode(addr);
    }

    /**
     * @notice Encodes a dynamic-sized array.
     */
    function encode_bytes() public pure returns (bytes memory) {
        bytes memory b = new bytes(3);
        b[0] = 0xab;
        b[1] = 0xab;
        b[2] = 0xab;
        return abi.encode(b);
    }
}

contract MemReturn {
    /**
     * @notice Demonstrates returning values directly from memory using inline assembly.
     */
    function test_return_vals() public pure returns (uint256, uint256) {
        assembly {
            mstore(0x80, 11) // Store value at 0x80
            mstore(0xa0, 22) // Store value at 0xa0
            return(0x80, 0x40) // Return 2 values (64 bytes)
        }
    }
}

contract MemRevert {
    /**
     * @notice Demonstrates reverting with a custom error message in memory.
     */
    function test_revert_with_error_msg() public pure {
        assembly {
            let p := mload(0x40) // Load free memory pointer
            mstore(p, shl(224, 0x08c379a0)) // Function selector for "Error(string)"
            mstore(add(p, 0x04), 0x20) // Offset to string data
            mstore(add(p, 0x24), 5) // String length
            mstore(add(p, 0x44), "ERROR") // Store string data
            revert(p, 0x64) // Revert with encoded error
        }
    }
}

contract MemExp {
    /**
     * @notice Measures gas costs associated with memory expansion.
     */
    function alloc_mem(uint256 n) external view returns (uint256) {
        uint256 gas_start = gasleft();
        uint256[] memory arr = new uint256[](n);
        uint256 gas_end = gasleft();
        return gas_start - gas_end;
    }
}
