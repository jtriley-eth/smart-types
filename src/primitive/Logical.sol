// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {As} from "src/primitive/As.sol";

using As for bool;

function truthy(Primitive self) pure returns (Primitive) {
    return self.isZero().isZero();
}

function falsy(Primitive self) pure returns (Primitive) {
    return self.isZero();
}

function logicalNot(Primitive self) pure returns (Primitive) {
    return self.isZero();
}
