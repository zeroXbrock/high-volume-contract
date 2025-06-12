// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

library Consumer {
    // #####################################################################
    // Permament storage
    // #####################################################################

    function sstore() internal {
        assembly {
            sstore(0, 0)
        }
    }

    function sload() internal view {
        assembly {
            let __ := sload(0)
        }
    }

    // #####################################################################
    // Memory
    // #####################################################################

    function mstore() internal pure {
        assembly {
            mstore(0, 0)
        }
    }

    function mload() internal pure {
        assembly {
            let __ := mload(0)
        }
    }

    // #####################################################################
    // Math
    // #####################################################################

    function add() internal pure {
        assembly {
            let __ := add(0x01, 0x01)
        }
    }

    function sub() internal pure {
        assembly {
            let __ := sub(0x01, 0x01)
        }
    }

    function mul() internal pure {
        assembly {
            let __ := mul(0x01, 0x13)
        }
    }

    function div() internal pure {
        assembly {
            let __ := div(0x13, 0x01)
        }
    }

    // #####################################################################
    // Precompiles
    // #####################################################################

    function ecrecover_() internal pure returns (address recovered) {
        recovered = ecrecover(
            0x84b9e10435e0bc5ea883d65dcc978b7d415228d21e4617775048722ef01a97e7,
            0x1c,
            0x7f05b09e99332068f90b5aa7233b53b9191ced11229aafe97f1a8d6e52af5dc5,
            0x049979df9965db093de9cac6c4224bd5bce586510fae94edcc513f12328b0685
        );
    }

    function hash_sha256(uint256 num) internal view returns (bytes32 h) {
        (bool ok, bytes memory out) = address(2).staticcall(abi.encode(num));
        require(ok, "failed");
        h = abi.decode(out, (bytes32));
    }

    function hash_ripemd160(uint256 num) internal view returns (bytes20 h) {
        (bool ok, bytes memory out) = address(3).staticcall(abi.encode(num));
        require(ok, "failed");
        h = bytes20(abi.decode(out, (bytes32)) << 96);
    }

    function identity(bytes memory input) internal view returns (bytes memory) {
        (bool ok, bytes memory out) = address(4).staticcall(abi.encode(input));
        require(ok, "failed");
        return out;
    }

    function modexp(
        uint256 base,
        uint256 exponent,
        uint256 modulus
    ) internal view returns (uint256 r) {
        (bool ok, bytes memory out) = address(5).staticcall(
            abi.encode(32, 32, 32, base, exponent, modulus)
        );
        require(ok, "failed");
        r = abi.decode(out, (uint256));
    }

    function ecAdd(
        uint256 x1,
        uint256 y1,
        uint256 x2,
        uint256 y2
    ) internal view returns (uint256 x3, uint256 y3) {
        bytes memory input = abi.encodePacked(x1, y1, x2, y2);
        (bool ok, bytes memory out) = address(6).staticcall(input);
        require(ok, "Elliptic curve addition failed");

        (x3, y3) = abi.decode(out, (uint256, uint256));
    }

    function ecMul(
        uint256 x,
        uint256 y,
        uint256 scalar
    ) internal view returns (uint256 xNew, uint256 yNew) {
        bytes memory input = abi.encodePacked(x, y, scalar);
        (bool ok, bytes memory out) = address(7).staticcall(input);
        require(ok, "Elliptic curve multiplication failed");

        (xNew, yNew) = abi.decode(out, (uint256, uint256));
    }

    function ecPairing(bytes memory input) internal view returns (bool) {
        (bool ok, bytes memory out) = address(8).staticcall(input);
        require(ok, "failed");

        return out.length == 32 && abi.decode(out, (uint256)) != 0;
    }

    /// adapted from https://github.com/ethereum/EIPs/blob/master/EIPS/eip-152.md#example-usage-in-solidity
    function blake2f(
        uint32 rounds,
        bytes32[2] memory h,
        bytes32[4] memory m,
        bytes8[2] memory t,
        bool f
    ) internal view returns (bytes32[2] memory) {
        bytes32[2] memory output;

        bytes memory args = abi.encodePacked(
            rounds,
            h[0],
            h[1],
            m[0],
            m[1],
            m[2],
            m[3],
            t[0],
            t[1],
            f
        );

        assembly {
            if iszero(
                staticcall(not(0), 0x09, add(args, 32), 0xd5, output, 0x40)
            ) {
                revert(0, 0)
            }
        }

        return output;
    }

    function blake2f(bytes memory input) internal view returns (bytes memory) {
        require(input.length == 213, "input length must be exactly 213 bytes");
        (bool success, bytes memory out) = address(0x09).staticcall(input);
        require(success, "Blake2f precompile failed");
        return out;
    }

    function kzgPointEvaluation(
        bytes memory input
    ) internal view returns (bool) {
        require(input.length == 192, "input length must be exactly 192 bytes");
        (bool success, bytes memory output) = address(0x0A).staticcall(input);
        require(success, "Point evaluation precompile failed");

        return output.length == 32 && abi.decode(output, (uint256)) != 0;
    }

    // #####################################################################
    // Misc
    // #####################################################################

    function keccak256_() internal pure {
        assembly {
            let ___ := keccak256(0x0, 0x20)
        }
    }

    function balance() internal view {
        address sendoor = msg.sender;
        assembly {
            let ___ := balance(sendoor)
        }
    }

    function caller() internal view {
        assembly {
            let ___ := caller()
        }
    }

    // #####################################################################
    // Additional Ethereum Opcodes
    // #####################################################################

    function stop() internal pure {
        assembly {
            stop()
        }
    }

    function return0() internal pure {
        assembly {
            return(0, 0)
        }
    }

    function revert0() internal pure {
        assembly {
            revert(0, 0)
        }
    }

    function invalid() internal pure {
        assembly {
            invalid()
        }
    }

    // function selfdestruct(address recipient) internal {
    //     assembly {
    //         selfdestruct(recipient)
    //     }
    // }

    function address_() internal view {
        assembly {
            let ___ := address()
        }
    }

    function origin() internal view {
        assembly {
            let ___ := origin()
        }
    }

    function gasprice() internal view {
        assembly {
            let ___ := gasprice()
        }
    }

    function gas() internal view {
        assembly {
            let ___ := gas()
        }
    }

    function codesize() internal pure {
        assembly {
            let ___ := codesize()
        }
    }

    function codecopy() internal pure {
        assembly {
            codecopy(0, 0, 0)
        }
    }

    function extcodesize() internal view {
        address a = address(this);
        assembly {
            let ___ := extcodesize(a)
        }
    }

    function extcodecopy() internal view {
        address a = address(this);
        assembly {
            extcodecopy(a, 0, 0, 0)
        }
    }

    function extcodehash() internal view {
        address a = address(this);
        assembly {
            let ___ := extcodehash(a)
        }
    }

    function returndatasize() internal pure {
        assembly {
            let ___ := returndatasize()
        }
    }

    function returndatacopy() internal pure {
        assembly {
            returndatacopy(0, 0, 0)
        }
    }

    function blockHash() internal view {
        uint256 blockNumber = block.number - 1; // Get the previous block hash
        assembly {
            let ___ := blockhash(blockNumber)
        }
    }

    function coinbase() internal view {
        assembly {
            let ___ := coinbase()
        }
    }

    function timestamp() internal view {
        assembly {
            let ___ := timestamp()
        }
    }

    function number() internal view {
        assembly {
            let ___ := number()
        }
    }

    function prevrandao() internal view {
        assembly {
            let ___ := prevrandao()
        }
    }

    function gaslimit() internal view {
        assembly {
            let ___ := gaslimit()
        }
    }

    function chainid() internal view {
        assembly {
            let ___ := chainid()
        }
    }

    function basefee() internal view {
        assembly {
            let ___ := basefee()
        }
    }

    function pop() internal pure {
        assembly {
            pop(0)
        }
    }

    function signextend() internal pure {
        assembly {
            let ___ := signextend(0, 0)
        }
    }

    function byte_() internal pure {
        assembly {
            let ___ := byte(0, 0)
        }
    }

    function shl() internal pure {
        assembly {
            let ___ := shl(1, 1)
        }
    }

    function shr() internal pure {
        assembly {
            let ___ := shr(1, 1)
        }
    }

    function sar() internal pure {
        assembly {
            let ___ := sar(1, 1)
        }
    }

    function not_() internal pure {
        assembly {
            let ___ := not(0)
        }
    }

    function and_() internal pure {
        assembly {
            let ___ := and(1, 1)
        }
    }

    function or_() internal pure {
        assembly {
            let ___ := or(1, 1)
        }
    }

    function xor_() internal pure {
        assembly {
            let ___ := xor(1, 1)
        }
    }

    function iszero() internal pure {
        assembly {
            let ___ := iszero(0)
        }
    }

    function lt() internal pure {
        assembly {
            let ___ := lt(1, 2)
        }
    }

    function gt() internal pure {
        assembly {
            let ___ := gt(2, 1)
        }
    }

    function slt() internal pure {
        assembly {
            let ___ := slt(1, 2)
        }
    }

    function sgt() internal pure {
        assembly {
            let ___ := sgt(2, 1)
        }
    }

    function eq() internal pure {
        assembly {
            let ___ := eq(1, 1)
        }
    }

    function msize() internal pure {
        assembly {
            let ___ := msize()
        }
    }

    function create(
        uint256 value,
        bytes memory code
    ) internal returns (address addr) {
        assembly {
            addr := create(value, add(code, 32), mload(code))
        }
    }

    function create2(
        uint256 value,
        bytes memory code,
        bytes32 salt
    ) internal returns (address addr) {
        assembly {
            addr := create2(value, add(code, 32), mload(code), salt)
        }
    }

    function call(
        address to,
        uint256 value,
        bytes memory data
    ) internal returns (bool success) {
        assembly {
            success := call(gas(), to, value, add(data, 32), mload(data), 0, 0)
        }
    }

    function callcode(
        address to,
        uint256 value,
        bytes memory data
    ) internal returns (bool success) {
        assembly {
            success := callcode(
                gas(),
                to,
                value,
                add(data, 32),
                mload(data),
                0,
                0
            )
        }
    }

    function delegatecall(
        address to,
        bytes memory data
    ) internal returns (bool success) {
        assembly {
            success := delegatecall(gas(), to, add(data, 32), mload(data), 0, 0)
        }
    }

    function staticcall_(
        address to,
        bytes memory data
    ) internal view returns (bool success) {
        assembly {
            success := staticcall(gas(), to, add(data, 32), mload(data), 0, 0)
        }
    }

    function log0(bytes memory data) internal {
        assembly {
            log0(add(data, 32), mload(data))
        }
    }

    function log1(bytes memory data, bytes32 topic1) internal {
        assembly {
            log1(add(data, 32), mload(data), topic1)
        }
    }

    function log2(bytes memory data, bytes32 topic1, bytes32 topic2) internal {
        assembly {
            log2(add(data, 32), mload(data), topic1, topic2)
        }
    }

    function log3(
        bytes memory data,
        bytes32 topic1,
        bytes32 topic2,
        bytes32 topic3
    ) internal {
        assembly {
            log3(add(data, 32), mload(data), topic1, topic2, topic3)
        }
    }

    function log4(
        bytes memory data,
        bytes32 topic1,
        bytes32 topic2,
        bytes32 topic3,
        bytes32 topic4
    ) internal {
        assembly {
            log4(add(data, 32), mload(data), topic1, topic2, topic3, topic4)
        }
    }
}
