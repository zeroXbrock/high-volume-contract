// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "./libs/Consumer.sol";

library Str {
    function equals(
        string memory a,
        string memory b
    ) internal pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}

contract SpamMe {
    bytes public inbox;

    using Str for string;

    function appendToInbox(bytes memory newMessage) public {
        inbox = abi.encodePacked(inbox, newMessage);
    }

    constructor() {
        inbox = "Hello, World!";
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

    function consumeGas(string memory method, uint256 iterations) public {
        if (method.equals("sstore")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.sstore();
            }
        } else if (method.equals("sload")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.sload();
            }
        } else if (method.equals("mstore")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.mstore();
            }
        } else if (method.equals("mload")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.mload();
            }
        } else if (method.equals("add")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.add();
            }
        } else if (method.equals("sub")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.sub();
            }
        } else if (method.equals("mul")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.mul();
            }
        } else if (method.equals("div")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.div();
            }
        } else if (method.equals("ecrecover")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.ecrecover_();
            }
        } else if (method.equals("keccak256")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.keccak256_();
            }
        } else if (method.equals("balance")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.balance();
            }
        } else if (method.equals("caller")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.caller();
            }
        }
    }

    function tipCoinbase() public payable {
        block.coinbase.transfer(msg.value);
    }
}
