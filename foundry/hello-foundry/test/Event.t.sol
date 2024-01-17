// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Event} from "../src/Event.sol";
import "forge-std/Test.sol";

contract EventTest is Test {
    Event public e;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    function setUp() public {
        e = new Event();
    }

    function testEmitTransferEvent() public {
        // what to check
        vm.expectEmit(true, true, false, true);

        // emit the expected event
        emit Transfer(address(this), address(123), 456);

        // call function that will emit the event
        e.transfer(address(this), address(123), 456);
    }

    function testEmitManyTransferEvents() public {
        address[] memory to = new address[](2);
        to[0] = address(123);
        to[1] = address(456);

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 777;
        amounts[1] = 888;

        for (uint256 i; i < to.length; i++) {
            // what to check
            vm.expectEmit(true, true, false, true);

            // emit the expected event
            emit Transfer(address(this), to[i], amounts[i]);
        }

        // call function that will emit the event
        e.transferMany(address(this), to, amounts);
    }
}
