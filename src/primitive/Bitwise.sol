// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {To} from "src/primitive/To.sol";
import {Constants} from "src/primitive/Constants.sol";
import {Error} from "src/primitive/Error.sol";

using To for uint256;

function shr(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.toUint256() >> rhs.toUint256()).toPrimitive();
}

function shl(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.toUint256() << rhs.toUint256()).toPrimitive();
}

function and(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.toUint256() & rhs.toUint256()).toPrimitive();
}

function or(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.toUint256() | rhs.toUint256()).toPrimitive();
}

function xor(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.toUint256() ^ rhs.toUint256()).toPrimitive();
}

function not(Primitive self) pure returns (Primitive) {
    return (~self.toUint256()).toPrimitive();
}

function mask(Primitive self, Primitive mask) pure returns (Primitive) {
    return self & mask;
}

function retainBits(Primitive self, Primitive bits) pure returns (Primitive) {
    return self & (shl(Constants.ONE, bits) - Constants.ONE);
}

function constrainBits(Primitive self, Primitive bits) pure returns (Primitive) {
    Primitive mask = shl(Constants.ONE, bits) - Constants.ONE;
    if (self > mask) revert Error.Overflow();
    return self;
}
