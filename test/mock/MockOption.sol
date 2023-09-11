// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Option, MemoryPointer} from "src/Prelude.sol";

contract MockOption {
    function expect(Option option, string calldata message) public pure returns (MemoryPointer) {
        return option.expect(message);
    }

    function unwrap(Option option) public pure returns (MemoryPointer) {
        return option.unwrap();
    }
}
