// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {To} from "src/primitive/To.sol";
import {Error} from "src/primitive/Error.sol";
import {Constants} from "src/primitive/Constants.sol";

using To for uint256;
using To for int256;

function eq(Primitive lhs, Primitive rhs) pure returns (bool) {
    return lhs.toUint256() == rhs.toUint256();
}

function gt(Primitive lhs, Primitive rhs) pure returns (bool) {
    return lhs.toUint256() > rhs.toUint256();
}

function lt(Primitive lhs, Primitive rhs) pure returns (bool) {
    return lhs.toUint256() < rhs.toUint256();
}

function add(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    (bool overflowed, Primitive result) = addOverflowing(lhs, rhs);
    if (overflowed) revert Error.Overflow();
    return result;
}

function sub(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    (bool underflowed, Primitive result) = subUnderflowing(lhs, rhs);
    if (underflowed) revert Error.Underflow();
    return result;
}

function mul(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    (bool overflowed, Primitive result) = mulOverflowing(lhs, rhs);
    if (overflowed) revert Error.Overflow();
    return result;
}

function div(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    (bool dividedByZero, Primitive result) = divByAny(lhs, rhs);
    if (dividedByZero) revert Error.DivisionByZero();
    return result;
}

function mod(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    (bool dividedByZero, Primitive result) = modByAny(lhs, rhs);
    if (dividedByZero) revert Error.DivisionByZero();
    return result;
}

function signedDiv(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    (bool dividedByZero, Primitive result) = signedDivByAny(lhs, rhs);
    if (dividedByZero) revert Error.DivisionByZero();
    return result;
}

function signedMod(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    (bool dividedByZero, Primitive result) = signedModByAny(lhs, rhs);
    if (dividedByZero) revert Error.DivisionByZero();
    return result;
}

function signedLt(Primitive lhs, Primitive rhs) pure returns (bool) {
    return lhs.toInt256() < rhs.toInt256();
}

function signedGt(Primitive lhs, Primitive rhs) pure returns (bool) {
    return lhs.toInt256() > rhs.toInt256();
}

function addOverflowing(Primitive lhs, Primitive rhs) pure returns (bool, Primitive) {
    unchecked {
        return (lhs > Constants.MAX - rhs, (lhs.toUint256() + rhs.toUint256()).toPrimitive());
    }
}

function subUnderflowing(Primitive lhs, Primitive rhs) pure returns (bool, Primitive) {
    unchecked {
        return (lhs < rhs, (lhs.toUint256() - rhs.toUint256()).toPrimitive());
    }
}

function mulOverflowing(Primitive lhs, Primitive rhs) pure returns (bool, Primitive) {
    unchecked {
        return (lhs > Constants.ZERO && rhs > Constants.MAX / lhs, (lhs.toUint256() * rhs.toUint256()).toPrimitive());
    }
}

function divByAny(Primitive lhs, Primitive rhs) pure returns (bool, Primitive) {
    unchecked {
        return (rhs.toUint256() == 0, (lhs.toUint256() / rhs.toUint256()).toPrimitive());
    }
}

function modByAny(Primitive lhs, Primitive rhs) pure returns (bool, Primitive) {
    unchecked {
        return (rhs.toUint256() == 0, (lhs.toUint256() % rhs.toUint256()).toPrimitive());
    }
}

function signedDivByAny(Primitive lhs, Primitive rhs) pure returns (bool, Primitive) {
    unchecked {
        return (rhs.toUint256() == 0, (lhs.toInt256() / rhs.toInt256()).toPrimitive());
    }
}

function signedModByAny(Primitive lhs, Primitive rhs) pure returns (bool, Primitive) {
    unchecked {
        return (rhs.toUint256() == 0, (lhs.toInt256() % rhs.toInt256()).toPrimitive());
    }
}

function extendSign(Primitive self, Primitive bits) pure returns (Primitive result) {
    if (bits > Constants.BIT_SIZE) revert Error.Overflow();
    assembly ("memory-safe") {
        result := signextend(div(bits, 8), self)
    }
}

function truncateSign(Primitive self, Primitive inputBits, Primitive outputBits) pure returns (Primitive result) {
    if (inputBits > Constants.BIT_SIZE || outputBits > inputBits) revert Error.Overflow();
    assembly ("memory-safe") {
        result := or(and(self, sub(shl(outputBits, 1), 1)), shl(sub(outputBits, 1), iszero(and(sub(inputBits, 1), self))))
    }
}
