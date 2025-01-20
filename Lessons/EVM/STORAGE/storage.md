# **STORAGE in the Ethereum Virtual Machine (EVM)**

Storage is a key component of the Ethereum Virtual Machine (EVM), responsible for persistent data management within smart contracts. Unlike memory and calldata, storage retains its values between transactions, making it the most expensive type of data storage in terms of gas costs.

---

## **1. Overview of Storage in the EVM**

Storage in the EVM is persistent and associated with the blockchain state. Each contract has its own 2^256 storage slots, where each slot is 32 bytes. Accessing storage is significantly more expensive than using memory or calldata, so understanding its intricacies is key to optimization.

### Key Points:

- Storage is a key-value store where keys are 32-byte words.
- Writing to storage (“SSTORE”) is expensive, while reading (“SLOAD”) is cheaper but still costly compared to memory or calldata.
- Data is stored in a deterministic layout defined by the Solidity compiler.

### Solidity’s Deterministic Storage Layout:

Solidity follows a predictable and consistent approach to assigning storage slots for variables, ensuring that data can be efficiently accessed and modified during contract execution. Here is how the compiler organizes data:

1. **Sequential Slot Allocation**: For simple types like `uint256` and `address`, variables are stored in consecutive slots, starting from slot 0.
2. **Packing Small Variables**: If multiple variables have sizes smaller than 32 bytes (e.g., `uint8`, `bool`), Solidity attempts to pack them into the same slot to save space.
3. **Dynamic Data Structures**: Complex structures like dynamic arrays, mappings, and structs have their storage determined using hashing mechanisms to ensure uniqueness.

For instance, a dynamic array’s length is stored at a base slot, while the actual elements start at the hashed value of the base slot. Mappings, on the other hand, calculate storage positions using a combination of the key and base slot.

---

## **2. Storage Layout for Solidity Data Types**

### **2.1 Simple Types**

Simple types like `uint256`, `bool`, and `address` are stored directly in storage slots. The first declared variable occupies slot 0, the second slot 1, and so on.

#### Example:

```solidity
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 public a; // Stored in slot 0
    bool public b;    // Stored in slot 1
    address public c; // Stored in slot 2
}
```

#### Assembly View:

```assembly
SLOAD 0x00  // Read value of `a`
SLOAD 0x01  // Read value of `b`
SLOAD 0x02  // Read value of `c`
```

---

### **2.2 Fixed-Size Arrays**

Fixed-size arrays store elements sequentially in consecutive slots.

#### Example:

```solidity
contract FixedArrayStorage {
    uint256[3] public arr; // arr[0]: slot 0, arr[1]: slot 1, arr[2]: slot 2
}
```

#### Assembly View:

```assembly
SLOAD 0x00  // arr[0]
SLOAD 0x01  // arr[1]
SLOAD 0x02  // arr[2]
```

---

### **2.3 Dynamic Arrays**

For a detailed implementation, refer to the [DynamicArraysInStorage.sol](./src/DynamicArraysInStorage.sol) file in the repository, which includes examples and assembly functions to explore dynamic arrays in storage.

Dynamic arrays use a "slot pointer" strategy. The length of the array is stored at the specified slot, and the elements are stored starting at `keccak256(slot)`.

#### Example:

```solidity
contract DynamicArrayStorage {
    uint256[] public arr; // Slot 0 stores length, elements start at keccak256(0)

    function setElement(uint256 index, uint256 value) external {
        arr[index] = value;
    }
}
```

#### Detailed Layout:

1. Slot 0: Stores the length of the array.
2. Elements: Start at `keccak256(0)`.

#### Assembly View:

```assembly
SLOAD 0x00                         // Load length of `arr`
PUSH1 0x00                         // Slot of `arr`
KECCAK256                          // Calculate storage offset
ADD                                // Add index to offset
SSTORE                             // Write value to calculated offset
```

---

### **2.4 Mappings**

Mappings are stored using a hash-based scheme. The storage slot for a mapping element is computed as `keccak256(key . slot)`.

#### Example:

```solidity
contract MappingStorage {
    mapping(address => uint256) public balances; // balances[key] stored at keccak256(key . 0)

    function updateBalance(address user, uint256 amount) external {
        balances[user] = amount;
    }
}
```

#### Detailed Layout:

- Each key-value pair in the mapping is stored at `keccak256(abi.encodePacked(key, slot))`.

#### Assembly View:

```assembly
PUSH1 0x00                         // Slot of `balances`
PUSH user_address                  // Address of the user (key)
MSTORE                             // Store key in memory
PUSH1 0x20                         // Key size
KEd o                     // Compute storage slot
SSTORE                             // Write value to computed slot
```

---

### **2.5 Structs**

Structs are stored sequentially, but each member starts in a new slot unless packed for optimization.

#### Example:

```solidity
contract StructStorage {
    struct Data {
        uint256 id;  // Slot 0
        address user; // Slot 1
    }
    Data public data;
}
```

#### Assembly View:

```assembly
SLOAD 0x00  // Load `data.id`
SLOAD 0x01  // Load `data.user`
```

---

## **3. Advanced Concepts and Optimizations**

### **3.1 Storage Packing**

Variables smaller than 32 bytes can be packed into a single slot to save gas.

#### Example:

```solidity
contract PackedStorage {
    uint128 public a; // Stored in lower 16 bytes of slot 0
    uint128 public b; // Stored in upper 16 bytes of slot 0
}
```

#### Assembly View:

```assembly
SLOAD 0x00  // Load packed slot
```

### **3.2 Reading/Writing Dynamic Data**

#### Example: Accessing a Dynamic Array Element

```solidity
uint256[] public dynamicArray;

function accessElement(uint256 index) external view returns (uint256) {
    return dynamicArray[index];
}
```

#### Assembly for Access:

```assembly
PUSH1 0x00                         // Slot for dynamic array
KECCAK256                          // Calculate starting offset
PUSH index                         // Add index
ADD                                // Calculate element position
SLOAD                              // Read value
```

---

## **4. Practical Examples and Exercises**

### Exercise 1: Calculate Storage Slot

Given a dynamic array `uint256[] public arr;`, find the slot for `arr[2]`.

#### Solution:

1. Compute the base slot: `0x00`.
2. Calculate `keccak256(0x00)`.
3. Add the index: `keccak256(0x00) + 2`.

---

## **5. Tools and Resources**

- **[EVM Codes](https://www.evm.codes/)**: Explore opcodes.
- **[Solidity Docs](https://soliditylang.org/docs/)**: Official documentation.
- **[Remix](https://remix.ethereum.org/)**: Online IDE for Solidity.


---

## **6. Key Takeaways**

- Storage is the most expensive and persistent data storage type in the EVM.
- Use efficient layouts and minimize writes to optimize gas usage.
- Understand the storage structure to debug and audit smart contracts effectively.

By mastering storage intricacies, developers can write efficient, gas-optimized smart contracts and unlock advanced capabilities of the EVM.

