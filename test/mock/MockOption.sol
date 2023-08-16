// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Option, SmartPointer} from "src/Prelude.sol";

contract MockOption {
    function expect(Option option, string calldata message) public pure returns (SmartPointer) {
        return option.expect(message);
    }

    function unwrap(Option option) public pure returns (SmartPointer) {
        return option.unwrap();
    }
}
