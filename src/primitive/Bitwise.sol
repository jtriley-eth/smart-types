// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {As} from "src/primitive/As.sol";
import {Constants} from "src/primitive/Constants.sol";
import {Error} from "src/primitive/Error.sol";

using As for uint256;

function shr(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.asUint256() >> rhs.asUint256()).asPrimitive();
}

function shl(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.asUint256() << rhs.asUint256()).asPrimitive();
}

function and(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.asUint256() & rhs.asUint256()).asPrimitive();
}

function or(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.asUint256() | rhs.asUint256()).asPrimitive();
}

function xor(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.asUint256() ^ rhs.asUint256()).asPrimitive();
}

function not(Primitive self) pure returns (Primitive) {
    return (~self.asUint256()).asPrimitive();
}

function retainBits(Primitive self, Primitive bits) pure returns (Primitive) {
    return self & (shl(Constants.ONE, bits) - Constants.ONE);
}

function constrainBits(Primitive self, Primitive bits) pure returns (Primitive) {
    Primitive mask = shl(Constants.ONE, bits) - Constants.ONE;
    if (self.gt(mask).asBool()) revert Error.Overflow();
    return self;
}

function getByte(Primitive self, Primitive index) pure returns (Primitive b) {
    assembly {
        b := byte(index, self)
    }
}
