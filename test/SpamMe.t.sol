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

    function test_fillStorage_num() public {
        uint256 numSlots = 100;
        spamMe.fillStorageSlots(numSlots, 1);
        for (uint256 i = 0; i < numSlots; i++) {
            bytes32 slotVal = spamMe.getStorageSlot(i);
            assertNotEq(slotVal, 0);
        }
    }

    function test_fillStorage_slots() public {
        uint256[] memory slots = new uint256[](100);
        for (uint256 i = 0; i < slots.length; i++) {
            slots[i] = i;
        }
        spamMe.fillStorageSlots(slots, 1);
        for (uint256 i = 0; i < slots.length; i++) {
            bytes32 slotVal = spamMe.getStorageSlot(i);
            assertNotEq(slotVal, 0);
        }
        uint256[] memory customSlots = new uint256[](4);
        customSlots[0] = 0xf00d;
        customSlots[1] = 0xdead;
        customSlots[2] = 0xbeef;
        customSlots[3] = 0xface;

        spamMe.fillStorageSlots(customSlots, 1);
        for (uint256 i = 0; i < customSlots.length; i++) {
            bytes32 slotVal = spamMe.getStorageSlot(customSlots[i]);
            assertNotEq(slotVal, 0);
        }
    }
}
