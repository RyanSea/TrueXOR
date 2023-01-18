## Solution
```solidity
function giveBool() external view returns (bool) {
    return gasleft() >= 4300 ? true : false;
}
```

## Vulernability
gasleft() changes between function calls and can be used as a kind of argument to give a different answer on either call

## POC
https://github.com/RyanSea/TrueXOR/blob/master/src/TrueXOR.t.sol