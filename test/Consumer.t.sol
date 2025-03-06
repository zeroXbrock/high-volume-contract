// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import {Test, console} from "forge-std/Test.sol";
import {Consumer} from "../src/libs/Consumer.sol";

contract ConsumerTest is Test {
    function test_ecrecover() public pure {
        address res = Consumer.ecrecover_();
        assertEq(res, address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266));
    }

    function test_sha256() public view {
        bytes32 res = Consumer.hash_sha256(0x42);
        assertEq(
            res,
            hex"aa796dee6b6abca795103a49a9715b499482dcf870f9237b2a7b03a3c93fd310"
        );
    }

    function test_ripemd160() public view {
        bytes20 res = Consumer.hash_ripemd160(0x42);
        assertEq(res, hex"aa02d9653163dc6830b9b6f9e03d74788702686c");
    }

    function test_identity() public view {
        bytes memory data = abi.encodePacked(hex"42");
        bytes memory res = abi.decode(Consumer.identity(data), (bytes));
        assertEq(res, data);
    }

    function test_modexp() public view {
        uint256 res = Consumer.modexp(2, 8, 9);
        assertEq(res, 4);
    }

    function test_ecAdd() public view {
        (uint256 x3, uint256 y3) = Consumer.ecAdd(1, 2, 0, 0);
        assertEq(x3, 1);
        assertEq(y3, 2);
    }

    function test_ecMul() public view {
        (uint256 x, uint256 y) = Consumer.ecMul(1, 2, 1);
        assertEq(x, 1);
        assertEq(y, 2);
    }

    function test_ecPairing() public view {
        // https://github.com/ethereum/tests/blob/develop/src/GeneralStateTestsFiller/stZeroKnowledge/ecpairing_inputsFiller.yml
        bytes
            memory input = hex"1b6e4577cc71df5e856ed88d2d14a464343f140b07693e3b08308570b28fd55b24198aa6ee0f5bfec020ad2ff15729434439e4af7554fa0f7395ee20cb926346246b8e8c771c3db7226a8066537632923d7d5a542f8e0d600e7f0195240f1ec513cbe706f9ba436dd4a781fab85fa2e9d82854446cf91182dcfa66eb68c4b7e72533a60b837f9cf4838c4c38f4f9c8988fee10c9895753e7925a86330e925db702f47f10f7da957cfcc613361ab6aaeb67f14d22c06eec14e47e36988c4ee06705a596bd22bbb13dc898acfdd420c88893dd09f7fd4875e8b3fb65b54ad9643f2847ab3c7d853e89cfdf520de28e1092c1955b7e17d9cba5808f047a3d6898fd2f64f057deda8bbb646d5b9864d9789a696abf2a42218f7af28baae517f5e45723bd3952d332068086b2079260b285896cb84c73ece3647094fac90d8b1374c21eebb3f8ea3c3d9147fa09e4506bcff1c222a02ea8b4904fc6df3bca1cc0505e133d9a4794eb099e9bdf82a6fecdb2e2e29b0867bf0fe557475dc758d796714e";
        bool res = Consumer.ecPairing(input);
        assert(res);

        input = hex"18dd52daaa11ff5dbb97c8776924d95b1bb86bf16481ba52519674873e0279ea0b32f4758cc18142794358e62b9c29951d3cb7e705d97e4cefd8422fa340ed5804cbac0707b92f59b87024017aae6941a3d8f42c6b93c619fa85cd54a3f0596325ef128bd051c44f95f7aa6122a390666691c2ec8a328f5302605f0aaae670db14a3194db0c978125b0212d2dbcf3639650e40f8acaeff5a5c20ba700de3966f004d3f0a629eb1456685db5a1b94d4b2f8dc0a9cdc5d29cccc5b596d88ba29fe0bcf53d38a1b0732fd90b73149559e0ee767f525875ebdb26f7f123136282afa28e440620ea4064d1f0190c75e2a36003f18643507a927926130eb54ecc1004d198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c21800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed090689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa";
        res = Consumer.ecPairing(input);
        assert(res);
    }

    function test_blake2() public view {
        // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-152.md#test-cases
        bytes memory res = Consumer.blake2f(
            hex"0000000148c9bdf267e6096a3ba7ca8485ae67bb2bf894fe72f36e3cf1361d5f3af54fa5d182e6ad7f520e511f6c3e2b8c68059b6bbd41fbabd9831f79217e1319cde05b61626300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000001"
        );
        assertEq(
            res,
            hex"b63a380cb2897d521994a85234ee2c181b5f844d2c624c002677e9703449d2fba551b3a8333bcdf5f2f7e08993d53923de3d64fcc68c034e717b9293fed7a421"
        );

        res = Consumer.blake2f(
            hex"0000000c48c9bdf267e6096a3ba7ca8485ae67bb2bf894fe72f36e3cf1361d5f3af54fa5d182e6ad7f520e511f6c3e2b8c68059b6bbd41fbabd9831f79217e1319cde05b61626300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000"
        );
        assertEq(
            res,
            hex"75ab69d3190a562c51aef8d88f1c2775876944407270c42c9844252c26d2875298743e7f6d5ea2f2d3e8d226039cd31b4e426ac4f2d3d666a610c2116fde4735"
        );
    }
}
