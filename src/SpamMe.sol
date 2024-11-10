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
        uint256 m = gas / 217;
        for (uint256 i = 0; i < m; i++) {
            assembly {
                sstore(0, 1)
            }
        }
    }

    function tipCoinbase() public payable {
        block.coinbase.transfer(msg.value);
    }
}
