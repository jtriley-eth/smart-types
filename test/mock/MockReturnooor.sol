// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockReturnooor {
    fallback() external {
        assembly {
            calldatacopy(0x00, 0x00, calldatasize())
            return(0x00, calldatasize())
        }
    }
}
