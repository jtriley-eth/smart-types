// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Option, Box} from "src/Prelude.sol";

contract MockOption {
    function expect(Option option, string calldata message) public pure returns (Box) {
        return option.expect(message);
    }

    function unwrap(Option option) public pure returns (Box) {
        return option.unwrap();
    }
}
