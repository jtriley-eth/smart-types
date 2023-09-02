// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {Fn} from "src/fn/Fn.sol";
import {Box} from "src/box/Box.sol";

library As {
    function asPrimitive(bool self) internal pure returns (Primitive p) {
        assembly {
            p := self
        }
    }

    function asPrimitive(address self) internal pure returns (Primitive) {
        return Primitive.wrap(uint160(self));
    }

    function asPrimitive(address payable self) internal pure returns (Primitive) {
        return Primitive.wrap(uint160(address(self)));
    }

    function asPrimitive(uint256 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(int256 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint256(self));
    }

    function asPrimitive(bytes32 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint256(self));
    }
}
