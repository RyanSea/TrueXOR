// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

interface IBoolGiver {
  function giveBool() external view returns (bool);
}

contract BoolGiver is IBoolGiver {
  function giveBool() external view returns (bool) {
    // review: gasleft() changes between the 2 calls 
    //         getting to 4300 from 8k gas took trial and error
    return gasleft() >= 4300 ? true : false;
  }
}

contract TrueXOR {
  function callMe(address target) external view returns (bool) {
    bool p = IBoolGiver(target).giveBool();
    bool q = IBoolGiver(target).giveBool();
    require((p && q) != (p || q), "bad bools");
    require(msg.sender == tx.origin, "bad sender");
    return true;
  }
}

contract TrueXORTest is Test {
    TrueXOR xor;
    BoolGiver boolGiver;

    function setUp() public {
        xor = new TrueXOR();
        boolGiver = new BoolGiver();
    }

    function testXOR() public {
        // keeps tx.origin the same despite call being from this test contract
        vm.prank(msg.sender);
        // call with 8k gas 
        bool answer = xor.callMe{ gas : 8000 }((address(boolGiver)));

        assertTrue(answer);
    }
}
