| Scientific Notation | Equivalent Integer Representation (in Wei) |
|---------------------|--------------------------------------------|
| 1e18                | 1000000000000000000                       |
| 1e6                 | 1000000                                   |
| 1e3                 | 1000                                      |
| 1e2                 | 100                                       |
| 1e1                 | 10                                        |
| 1e0                 | 1                                         |

1 Ether = 1000000000000000000 Wei's.


### Good Practices for Representing Decimals in Solidity

When working with Solidity and ERC20 tokens, it's essential to properly handle decimals to avoid errors in calculations. ERC20 tokens typically have a `decimals` property that indicates the number of decimal places the token supports. Here are some best practices:

1. **Convert Values to Token Units:**
   - To represent $50 for a token with 18 decimals, multiply the value by `10^18`:
     ```solidity
     uint256 amount = 50 * 10**18; // Represents $50 in token units
     ```

2. **Convert Values from Token Units:**
   - To convert a token amount back to a human-readable format, divide by `10^decimals`:
     ```solidity
     uint256 humanReadable = tokenAmount / 10**18;
     ```

3. **Performing Math Operations:**
   - Always use token units for calculations to maintain precision. For example, when adding or subtracting amounts:
     ```solidity
     uint256 total = amount1 + amount2; // Both should be in token units
     ```

4. **Handling Different Tokens:**
   - If dealing with multiple tokens, ensure that you normalize their values to the same decimal base before performing operations.

5. **Using Safe Math Libraries:**
   - Use libraries like OpenZeppelin's `SafeMath` to prevent overflow and underflow errors when performing arithmetic operations.

6. **Reading Token Decimals:**
   - When interacting with tokens dynamically, retrieve the `decimals` property from the token contract:
     ```solidity
     uint8 decimals = IERC20(token).decimals();
     uint256 amount = 50 * 10**decimals;
     ```

### Working with Chainlink Price Feeds

Chainlink price feeds return prices with varying decimals depending on the asset pair. For example, ETH/USD typically has 18 decimals, while BTC/USD has 8 decimals. Here are best practices for handling these feeds:

1. **Retrieve Decimals Dynamically:**
   - Chainlink price feeds expose a `decimals()` function. Always retrieve the decimals to normalize calculations:
     ```solidity
     uint8 decimals = AggregatorV3Interface(priceFeed).decimals();
     ```

2. **Normalize Price Values:**
   - Normalize the price to a common decimal base (e.g., 18 decimals) for consistent calculations. For example, if the price returned is $23,456.78 (in 8 decimals):
     ```solidity
     ( , int256 price, , , ) = AggregatorV3Interface(priceFeed).latestRoundData();
     uint256 normalizedPrice = uint256(price) * 10**(18 - decimals);
     // Normalized price = 23,456.78 * 10^10 = 23,456,780,000,000,000,000
     ```

3. **Create a Generic Function:**
   - Implement a generic function to fetch and normalize prices:
     ```solidity
     function getPrice(address priceFeed) public view returns (uint256) {
         uint8 decimals = AggregatorV3Interface(priceFeed).decimals();
         ( , int256 price, , , ) = AggregatorV3Interface(priceFeed).latestRoundData();
         return uint256(price) * 10**(18 - decimals);
     }
     ```

4. **Perform Calculations Consistently:**
   - Use the normalized prices for further calculations. For instance, converting a USD value to ETH:
     ```solidity
     uint256 ethAmount = usdAmount * 10**18 / getPrice(ethUsdPriceFeed);
     ```

5. **Account for Precision:**
   - Ensure calculations consider the precision of the normalized values to avoid rounding errors.
