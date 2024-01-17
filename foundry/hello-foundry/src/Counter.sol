// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/console.sol";

contract Counter {
    uint256 public count;

    function get() public view returns (uint256) {
        console.log("get() called");
        return count;
    }

    function inc() public {
        console.log("inc() called");
        count += 1;
    }

    function dec() public {
        console.log("dec() called");
        count -= 1;
    }
}
