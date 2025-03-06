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
    ) public view returns (uint256 x3, uint256 y3) {
        bytes memory input = abi.encodePacked(x1, y1, x2, y2);
        (bool ok, bytes memory out) = address(6).staticcall(input);
        require(ok, "Elliptic curve addition failed");

        (x3, y3) = abi.decode(out, (uint256, uint256));
    }

    function ecMul(
        uint256 x,
        uint256 y,
        uint256 scalar
    ) public view returns (uint256 xNew, uint256 yNew) {
        bytes memory input = abi.encodePacked(x, y, scalar);
        (bool ok, bytes memory out) = address(7).staticcall(input);
        require(ok, "Elliptic curve multiplication failed");

        (xNew, yNew) = abi.decode(out, (uint256, uint256));
    }

    function ecPairing(bytes memory input) public view returns (bool) {
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
    ) public view returns (bytes32[2] memory) {
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

    function kzgPointEvaluation(bytes memory input) public view returns (bool) {
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
}
