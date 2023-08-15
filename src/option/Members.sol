// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";

enum Members {
    None,
    Some
}

using { asPrimitive } for Members global;
using LibMembers for Members global;

library LibMembers {
    function asMembers(Primitive self) internal pure returns (Members m) {
        assembly {
            m := self
        }
    }
}

function asPrimitive(Members self) pure returns (Primitive p) {
    assembly {
        p := self
    }
}
