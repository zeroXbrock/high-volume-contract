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
    // Misc
    // #####################################################################

    function ecrecover_() internal pure {
        address ___ = ecrecover(
            0x7b05e003631381b3ecd0222e748a7900c262a008c4b7f002ce4a9f0a19061953, //keccak256(bytes("recover this!")),
            0x42,
            0x0000000000000000000000000000000000000000000000000000000000000042, //bytes32(uint256(0x42)),
            0x0000000000000000000000000000000000000000000000000000000000000042
        );
        ___;
    }

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
