// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";

enum ArgKind {
    Function,
    Concrete
}

using { asPrimitive } for ArgKind global;

function asPrimitive(ArgKind self) pure returns (Primitive) {
    return Primitive.wrap(uint256(self));
}
