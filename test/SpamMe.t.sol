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
        // spamMe.consumeGas(250000);
        // spamMe.consumeGas(1750000);
    }

    function testFuzz_AppendToInbox(bytes memory x) public {
        spamMe.appendToInbox(x);
        assertEq(spamMe.inbox(), x);
    }
}
