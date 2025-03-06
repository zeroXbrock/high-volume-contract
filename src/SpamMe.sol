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
    uint256 sampleNum;
    bytes sampleBytes;

    using Str for string;

    constructor() {
        inbox = "";
        sampleNum = uint256(keccak256(abi.encodePacked("fourty-two")));
        sampleBytes = abi.encodePacked("Hello, World!");
    }

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

    function callPrecompile(
        string memory method,
        uint256 iterations
    ) public view {
        if (method.equals("hash_sha256")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.hash_sha256(sampleNum);
            }
        } else if (method.equals("hash_ripemd160")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.hash_ripemd160(sampleNum);
            }
        } else if (method.equals("identity")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.identity(sampleBytes);
            }
        } else if (method.equals("modexp")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.modexp(10, 4, 14);
            }
        } else if (method.equals("ecAdd")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.ecAdd(42, 32, 55, 44);
            }
        } else if (method.equals("ecMul")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.ecMul(10, 10, 4);
            }
        } else if (method.equals("ecPairing")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.ecPairing(
                    hex"1b6e4577cc71df5e856ed88d2d14a464343f140b07693e3b08308570b28fd55b24198aa6ee0f5bfec020ad2ff15729434439e4af7554fa0f7395ee20cb926346246b8e8c771c3db7226a8066537632923d7d5a542f8e0d600e7f0195240f1ec513cbe706f9ba436dd4a781fab85fa2e9d82854446cf91182dcfa66eb68c4b7e72533a60b837f9cf4838c4c38f4f9c8988fee10c9895753e7925a86330e925db702f47f10f7da957cfcc613361ab6aaeb67f14d22c06eec14e47e36988c4ee06705a596bd22bbb13dc898acfdd420c88893dd09f7fd4875e8b3fb65b54ad9643f2847ab3c7d853e89cfdf520de28e1092c1955b7e17d9cba5808f047a3d6898fd2f64f057deda8bbb646d5b9864d9789a696abf2a42218f7af28baae517f5e45723bd3952d332068086b2079260b285896cb84c73ece3647094fac90d8b1374c21eebb3f8ea3c3d9147fa09e4506bcff1c222a02ea8b4904fc6df3bca1cc0505e133d9a4794eb099e9bdf82a6fecdb2e2e29b0867bf0fe557475dc758d796714e"
                );
            }
        } else if (method.equals("blake2f")) {
            Consumer.blake2f(
                hex"0000000148c9bdf267e6096a3ba7ca8485ae67bb2bf894fe72f36e3cf1361d5f3af54fa5d182e6ad7f520e511f6c3e2b8c68059b6bbd41fbabd9831f79217e1319cde05b61626300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000001"
            );
        } else if (method.equals("blake2f_alt")) {
            uint32 rounds = 12;

            bytes32[2] memory h;
            h[
                0
            ] = 0x48c9bdf267e6096a3ba7ca8485ae67bb2bf894fe72f36e3cf1361d5f3af54fa5;
            h[
                1
            ] = 0xd182e6ad7f520e511f6c3e2b8c68059b6bbd41fbabd9831f79217e1319cde05b;

            bytes32[4] memory m;
            m[
                0
            ] = 0x6162630000000000000000000000000000000000000000000000000000000000;
            m[1] = bytes32(0);
            m[2] = bytes32(0);
            m[3] = bytes32(0);

            bytes8[2] memory t;
            t[0] = 0x0300000000000000;
            t[1] = 0;

            bool f = true;

            for (uint256 i = 0; i < iterations; i++) {
                Consumer.blake2f(rounds, h, m, t, f);
            }
        }
        // else if (method.equals("kzgPointEvaluation")) {
        //     // TODO: valid inputs
        //     for (uint256 i = 0; i < iterations; i++) {
        //         Consumer.kzgPointEvaluation();
        //     }
        // }
    }

    function tipCoinbase() public payable {
        block.coinbase.transfer(msg.value);
    }

    function revertOddBlocks() public view {
        if (block.timestamp % 2 != 0) {
            revert("block was odd, and I don't like that");
        }
        // consume some gas
        for (uint256 i = 0; i < 100; i++) {
            Consumer.mload();
        }
    }
}
