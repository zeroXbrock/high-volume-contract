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
    uint256 public sampleNum;
    bytes public sampleBytes;

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

    function getThis() public view returns (address) {
        return address(this);
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

    function getStorageSlot(uint256 slot) public view returns (bytes32) {
        bytes32 value;
        assembly {
            value := sload(slot)
        }
        return value;
    }

    /** Fills given storage slots with new values for each iteration. */
    function fillStorageSlots(
        uint256[] memory slots,
        uint256 iterations
    ) public {
        require(slots.length > 0, "Slots array must not be empty");
        require(iterations > 0, "Iterations must be greater than 0");

        for (uint256 i = 0; i < iterations; i++) {
            for (uint256 j = 0; j < slots.length; j++) {
                uint256 slot = slots[j];
                assembly {
                    // fill storage slots with hash of the slot index
                    let tmp := mul(add(i, 1), add(j, 1))
                    mstore(0x00, tmp)
                    let idxhash := keccak256(0x00, 0x20)
                    sstore(slot, idxhash)
                }
            }
        }
    }

    /** Fills a given number of storage slots with new values for each iteration. */
    function fillStorageSlots(uint256 numSlots, uint256 iterations) public {
        require(numSlots > 0, "Number of slots must be greater than 0");
        require(iterations > 0, "Iterations must be greater than 0");

        for (uint256 i = 0; i < iterations; i++) {
            for (uint256 j = 0; j < numSlots; j++) {
                assembly {
                    let tmp := mul(add(i, 1), add(j, 1))
                    mstore(0x00, tmp) // write (i + 1) * (j + 1) to memory at 0x00
                    let idxhash := keccak256(0x00, 0x20)
                    sstore(j, idxhash) // store the hash in storage slot j
                }
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
        } else if (method.equals("stop")) {
            Consumer.stop();
        } else if (method.equals("return")) {
            Consumer.return0();
        } else if (method.equals("revert")) {
            Consumer.revert0();
        } else if (method.equals("invalid")) {
            Consumer.invalid();
        }
        // else if (method.equals("selfdestruct")) {
        //     for (uint256 i = 0; i < iterations; i++) {
        //         Consumer.selfdestruct();
        //     }
        // }
        else if (method.equals("address")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.address_();
            }
        } else if (method.equals("origin")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.origin();
            }
        } else if (method.equals("gasprice")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.gasprice();
            }
        } else if (method.equals("gas")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.gas();
            }
        } else if (method.equals("codesize")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.codesize();
            }
        } else if (method.equals("codecopy")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.codecopy();
            }
        } else if (method.equals("extcodesize")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.extcodesize();
            }
        } else if (method.equals("extcodecopy")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.extcodecopy();
            }
        } else if (method.equals("extcodehash")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.extcodehash();
            }
        } else if (method.equals("returndatasize")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.returndatasize();
            }
        } else if (method.equals("returndatacopy")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.returndatacopy();
            }
        } else if (method.equals("blockHash")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.blockHash();
            }
        } else if (method.equals("coinbase")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.coinbase();
            }
        } else if (method.equals("timestamp")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.timestamp();
            }
        } else if (method.equals("number")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.number();
            }
        } else if (method.equals("prevrandao")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.prevrandao();
            }
        } else if (method.equals("gaslimit")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.gaslimit();
            }
        } else if (method.equals("chainid")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.chainid();
            }
        } else if (method.equals("basefee")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.basefee();
            }
        } else if (method.equals("pop")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.pop();
            }
        } else if (method.equals("signextend")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.signextend();
            }
        } else if (method.equals("byte")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.byte_();
            }
        } else if (method.equals("shl")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.shl();
            }
        } else if (method.equals("shr")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.shr();
            }
        } else if (method.equals("sar")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.sar();
            }
        } else if (method.equals("not")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.not_();
            }
        } else if (method.equals("and")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.and_();
            }
        } else if (method.equals("or")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.or_();
            }
        } else if (method.equals("xor")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.xor_();
            }
        } else if (method.equals("iszero")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.iszero();
            }
        } else if (method.equals("lt")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.lt();
            }
        } else if (method.equals("gt")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.gt();
            }
        } else if (method.equals("slt")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.slt();
            }
        } else if (method.equals("sgt")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.sgt();
            }
        } else if (method.equals("eq")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.eq();
            }
        } else if (method.equals("msize")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.msize();
            }
        } else if (method.equals("create")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.create(0, type(Consumer).creationCode);
            }
        } else if (method.equals("create2")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.create2(
                    0,
                    type(Consumer).creationCode,
                    keccak256(abi.encodePacked(address(this)))
                );
            }
        } else if (method.equals("call")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.call(
                    address(this),
                    0,
                    abi.encodeWithSelector(this.sampleNum.selector)
                );
            }
        } else if (method.equals("callcode")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.callcode(
                    address(this),
                    0,
                    abi.encodeWithSelector(this.getThis.selector)
                );
            }
        } else if (method.equals("delegatecall")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.delegatecall(
                    address(this),
                    abi.encodeWithSelector(this.getThis.selector)
                );
            }
        } else if (method.equals("staticcall")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.staticcall_(
                    address(this),
                    abi.encodeWithSelector(this.getThis.selector)
                );
            }
        } else if (method.equals("log0")) {
            bytes memory data = abi.encodePacked("logging is a worthwhile job");
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.log0(data);
            }
        } else if (method.equals("log1")) {
            bytes memory data = abi.encodePacked("logging is a worthwhile job");
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.log1(data, bytes32(uint256(0xf00d)));
            }
        } else if (method.equals("log2")) {
            bytes memory data = abi.encodePacked("logging is a worthwhile job");
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.log2(
                    data,
                    bytes32(uint256(0xf00d)),
                    bytes32(uint256(0xdead))
                );
            }
        } else if (method.equals("log3")) {
            bytes memory data = abi.encodePacked("logging is a worthwhile job");
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.log3(
                    data,
                    bytes32(uint256(0xdead)),
                    bytes32(uint256(0xbeef)),
                    bytes32(uint256(0xface))
                );
            }
        } else if (method.equals("log4")) {
            bytes memory data = abi.encodePacked("logging is a worthwhile job");
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.log4(
                    data,
                    bytes32(uint256(0xbeef)),
                    bytes32(uint256(0xface)),
                    bytes32(uint256(0xfeed)),
                    bytes32(uint256(0xcafe))
                );
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
                Consumer.ecAdd(1, 2, 0, 0);
            }
        } else if (method.equals("ecMul")) {
            for (uint256 i = 0; i < iterations; i++) {
                Consumer.ecMul(1, 2, 1);
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

    function revertIfTrue(
        bool doRevert,
        bytes calldata call_data
    ) public returns (bytes memory) {
        if (doRevert) {
            revert("Reverted because doRevert was true");
        }
        if (call_data.length > 0) {
            (bool success, bytes memory res) = address(this).call(call_data);
            if (!success) {
                revert("Reverted because call(call_data) failed");
            }
            return res;
        }
        return "";
    }
}

contract ConsumerPublic {
    function hash_sha256(uint256 num) public view {
        Consumer.hash_sha256(num);
    }

    function hash_ripemd160(uint256 num) public view {
        Consumer.hash_ripemd160(num);
    }

    function identity(bytes calldata data) public view {
        Consumer.identity(data);
    }

    function modexp(
        uint256 base,
        uint256 exponent,
        uint256 modulus
    ) public view {
        Consumer.modexp(base, exponent, modulus);
    }

    function ecAdd(uint256 x1, uint256 y1, uint256 x2, uint256 y2) public view {
        Consumer.ecAdd(x1, y1, x2, y2);
    }

    function ecMul(uint256 x, uint256 y, uint256 scalar) public view {
        Consumer.ecMul(x, y, scalar);
    }

    function ecPairing(bytes calldata data) public view {
        Consumer.ecPairing(data);
    }

    function blake2f(bytes calldata data) public view {
        Consumer.blake2f(data);
    }

    function kzgPointEvaluation(bytes calldata input) public view {
        Consumer.kzgPointEvaluation(input);
    }
}
