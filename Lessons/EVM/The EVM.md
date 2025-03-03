# **Mastering the Ethereum Virtual Machine (EVM)**

The Ethereum Virtual Machine (EVM) is the backbone of blockchain development and security auditing. This document provides an overview of the EVM. For deeper dives into each component, refer to the linked sections below.

---

## **How to Navigate**
This guide is modular. Each section links to detailed explanations and practical examples:
- [STACK](./STACK/stack.md)
- [MEMORY](./MEMORY/memory.md)
- [STORAGE](./STORAGE/storage.md)
- [CALLDATA](./CALLDATA/calldata.md)
- [CODE](./CODE/code.md)
- [LOGS](./LOGS/logs.md)

---

## **1. Data Storage in the EVM**

The EVM organizes data into six key areas:

### **1.1 Stack**
- A Last-In-First-Out (LIFO) data structure for 32-byte words.
- Handles immediate values such as integers, addresses, and pointers.
- Operates via `PUSH`, `POP`, and `SWAP` opcodes.

[Learn more about stack operations](./STACK/stack.md).

#### **Example: Basic Stack Operations**
```assembly
PUSH1 0x05    // Push 5 onto the stack
PUSH1 0x03    // Push 3 onto the stack
ADD           // Add 3 and 5, result: 8
PUSH1 0x02    // Push 2 onto the stack
MUL           // Multiply 8 and 2, result: 16
```

### **1.2 Memory**
- Byte-addressable and temporary for transaction duration.
- Dynamically allocated in 32-byte words.
- Reserved areas include:
  - `0x00–0x20`: Scratch space.
  - `0x40`: Free memory pointer.
  - `0x60`: Reserved for dynamic arrays.

[Learn more about memory management](./MEMORY/memory.md).

#### **Example: Memory Operations**
```assembly
PUSH1 0x10    // Value to store
PUSH1 0x00    // Memory address
MSTORE        // Store 0x10 at address 0x00
PUSH1 0x00    // Memory address
MLOAD         // Load 0x10 from address 0x00
```

### **1.3 Call Data**
- Read-only, immutable data sent with transactions.
- Efficient for passing input parameters.
- Only applies to reference types (e.g., arrays, strings, structs) when used as a parameter location.
- For value types (e.g., uint256, bool, address), the calldata location is not specified because they are passed by value.

[Learn more about calldata](./CALLDATA/calldata.md).

#### **Example: Reading Call Data**
```solidity
function doubleInput(uint256 input) external pure returns (uint256) {
    return input * 2;
}
```
Call data for `doubleInput(5)`:
```
0x2e64cec1 // Function selector
0000000000000000000000000000000000000000000000000000000000000005 // Input value
```

## Example: Using calldata for Reference Types
```solidity
function doubleInputs(uint256[] calldata inputs) external pure returns (uint256[] memory) {
    uint256[] memory result = new uint256[](inputs.length);
    for (uint256 i = 0; i < inputs.length; i++) {
        result[i] = inputs[i] * 2;
    }
    return result;
}
```
In this case, the parameter inputs is a dynamic array of uint256, and the calldata location ensures that:

1. The array is read-only and immutable.
2. Memory usage is minimized, as calldata allows direct access to the data in the transaction.

### **1.4 Storage**
- Persistent, mapped to contract addresses, and expensive in gas.
- Organized in 32-byte slots.

[Learn more about storage](./STORAGE/storage.md).

#### **Example: Storage Interaction**
```solidity
uint256 public storedData;

function storeData(uint256 data) external {
    storedData = data; // SSTORE operation
}

function readData() external view returns (uint256) {
    return storedData; // SLOAD operation
}
```

### **1.5 Code**
- Immutable bytecode stored at the contract address.
- Executes functions as defined at deployment.

[Learn more about code](./CODE/code.md).

### **1.6 Logs**
- Write-only, used for emitting events.
- Useful for off-chain applications and debugging.

[Learn more about logs](./LOGS/logs.md).

#### **Example: Emitting an Event**
```solidity
event DataStored(address indexed user, uint256 data);

function storeData(uint256 data) external {
    emit DataStored(msg.sender, data);
}
```

---

## **2. Key Operations in the EVM**

### **2.1 Stack Operations**
- **`PUSH`**: Adds a word to the stack.
- **`POP`**: Removes the top item.
- **`SWAP`**: Reorders stack items.

[Learn more about stack operations](./STACK/stack.md).

#### **Example: SWAP**
```assembly
PUSH1 0x01    // Stack: [0x01]
PUSH1 0x02    // Stack: [0x02, 0x01]
SWAP1         // Stack: [0x01, 0x02]
```

### **2.2 Memory Operations**
- **`MSTORE`**: Write a word to memory.
- **`MLOAD`**: Read a word from memory.
- **`MSTORE8`**: Store a single byte.

[Learn more about memory operations](./MEMORY/memory.md).

#### **Example: Memory Usage**
```assembly
PUSH1 0x2A    // Value to store
PUSH1 0x20    // Memory address
MSTORE        // Store 0x2A at 0x20
PUSH1 0x20    // Memory address
MLOAD         // Load 0x2A from 0x20
```

### **2.3 Storage Operations**
- **`SSTORE`**: Write to storage (gas-intensive).
- **`SLOAD`**: Read from storage.

[Learn more about storage operations](./STORAGE/storage.md).

#### **Example: Storage Operation**
```assembly
PUSH1 0x05    // Value to store
PUSH1 0x00    // Storage slot
SSTORE        // Store 0x05 in slot 0x00
```

---

## **3. Transaction Execution and Optimization**

### **3.1 Function Selectors**
- First 4 bytes of the `keccak256` hash of a function signature determine which function to execute.

#### **Example: Selector for `transfer(address,uint256)`**
```solidity
keccak256("transfer(address,uint256)") = 0xa9059cbb
```

[Learn more about function selectors](./CODE/code.md).

### **3.2 Gas Efficiency Tips**
- Minimize `SSTORE` and `SLOAD`.
- Use `CALLDATA` directly for read-only operations.
- Optimize memory allocation to avoid unnecessary expansion.

[Learn more about gas optimizations](./STORAGE/storage.md).

#### **Example: Avoiding Costly Memory Expansion**
```assembly
PUSH1 0x20    // Value
PUSH1 0x8000  // Far memory address
MSTORE        // Expands memory, increasing gas costs
```

---

## **4. Resources**

- **[Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/)**: Formal specification of the EVM.
- **[EVM Codes](https://www.evm.codes/)**: Interactive opcode explorer.

---

## **Conclusion**

Mastery of the EVM enables efficient contract development and robust security practices. By understanding stack mechanics, storage layers, and gas optimizations, developers can create high-performance decentralized applications while minimizing costs.

---

