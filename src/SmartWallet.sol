// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract DelegatedSmartAccount {
    struct Call {
        address to;
        uint256 value;
        bytes data;
    }

    function execute(Call[] calldata calls) external payable {
        for (uint i = 0; i < calls.length; ++i) {
            (bool success, ) = calls[i].to.call{value: calls[i].value}(
                calls[i].data
            );
            require(success, "call failed");
        }
    }

    receive() external payable {}

    fallback() external payable {}
}
