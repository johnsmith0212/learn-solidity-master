// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {Error} from "../src/Error.sol";

contract ErrorTest is Test {
    Error public err;

    function setUp() public {
        err = new Error();
    }

    function testFail() public view {
        err.throwError();
    }

    function testRevert() public {
        vm.expectRevert();
        err.throwError();
    }

    function testRequireMessage() public {
        vm.expectRevert(bytes("not authorized"));
        err.throwError();
    }

    function testCustomError() public {
        vm.expectRevert(Error.NotAuthorized.selector);
        err.throwCustomError();
    }

    function testErrorLabel() public {
        assertEq(uint256(1), uint256(1), "1 == 1");
        assertEq(uint256(1), uint256(1), "1 == 1");
        assertEq(uint256(1), uint256(1), "1 == 1");
        assertEq(uint256(1), uint256(1), "1 == 1");
        assertEq(uint256(1), uint256(1), "1 == 1");
    }
}
