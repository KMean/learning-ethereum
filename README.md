# Learning Ethereum

This repository is a collection of examples and useful smart contracts that I am building while learning about Ethereum and Solidity. The purpose is to document my journey, share knowledge, and provide references for myself and others interested in Ethereum development.

## Overview

This repository includes / will include:
- Basic Solidity examples demonstrating key concepts.
- Useful smart contracts for learning and experimenting.
- Comments and explanations for clarity and understanding.

## Contracts

### 1. [DynamicArraySInStorage.sol](src/storage/DynamicArraysInStorage.sol)
Demonstrates how Solidity organizes storage for state variables, particularly dynamic arrays. Key features include:
- Adding elements to a dynamic array.
- Reading raw storage slots.
- Computing `keccak256` hashes of storage slots for array indexing.

### 2. [DynamicArraysInMemory.sol](src/memory/DynamicArraysInMemory.sol)
Explores the memory layout and gas costs associated with dynamic arrays in Solidity. Key features include:
- Probing memory slots for dynamic arrays.
- Demonstrating memory expansion and its quadratic gas cost.
- An example function that intentionally causes a gas exhaustion error.


## How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/KMean/learning-ethereum.git
   cd learning-ethereum
   ```
2. Install dependencies for testing or deploying:
```bash
forge build
```
3. Run Tests
```bash
forge test
```