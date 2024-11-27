// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract SpamMe {
    bytes public inbox;

    function appendToInbox(bytes memory newMessage) public {
        inbox = abi.encodePacked(inbox, newMessage);
    }

    function consumeGas() public view {
        while (gasleft() > 50) {
            gasleft();
        }
    }

    /// This should work with estimate_gas()
    function consumeGas(uint256 gas) public {
        require(gas > 0, "Gas must be greater than 0");

        uint256 iterations = (gas - 2600) / 149;
        if (iterations == 0) iterations = 1;

        for (uint256 i = 0; i < iterations; i++) {
            assembly {
                sstore(0, 0) // Simple no-op to burn gas
            }
        }
    }

    function tipCoinbase() public payable {
        block.coinbase.transfer(msg.value);
    }
}
