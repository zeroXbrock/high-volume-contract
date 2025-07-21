// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import {Test, console} from "forge-std/Test.sol";
import {SpamMe} from "../src/SpamMe.sol";

contract SpamTest is Test {
    SpamMe public spamMe;

    function setUp() public {
        spamMe = new SpamMe();
    }

    function test_AppendToInbox() public {
        spamMe.appendToInbox("Hello, ");
        spamMe.appendToInbox("World!");
        assertEq(spamMe.inbox(), "Hello, World!");
    }

    function test_consumeGas() public view {
        spamMe.consumeGas{gas: 500000}();
    }

    function test_consumeGasAlt() public {
        spamMe.consumeGas(100000);
        spamMe.consumeGas(250000);
        spamMe.consumeGas(1750000);
        spamMe.consumeGas(29000000);
    }

    function testFuzz_AppendToInbox(bytes memory input) public {
        bytes memory prevInbox = spamMe.inbox();
        spamMe.appendToInbox(input);
        assertEq(abi.encodePacked(prevInbox, input), spamMe.inbox());
    }

    function test_consumeGasAndRevert() public {
        vm.expectRevert();
        spamMe.consumeGasAndRevert(120000);
    }
}
