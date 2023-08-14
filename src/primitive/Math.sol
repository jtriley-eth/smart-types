// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {As} from "src/primitive/As.sol";
import {Error} from "src/primitive/Error.sol";
import {Constants} from "src/primitive/Constants.sol";

using As for uint256;
using As for int256;
using As for bool;

function eq(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.asUint256() == rhs.asUint256()).asPrimitive();
}

function gt(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.asUint256() > rhs.asUint256()).asPrimitive();
}

function lt(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.asUint256() < rhs.asUint256()).asPrimitive();
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
    return lhs.asInt256() < rhs.asInt256();
}

function signedGt(Primitive lhs, Primitive rhs) pure returns (bool) {
    return lhs.asInt256() > rhs.asInt256();
}

function addOverflowing(Primitive lhs, Primitive rhs) pure returns (bool, Primitive) {
    unchecked {
        return (lhs.gt(Constants.MAX.sub(rhs)).asBool(), (lhs.asUint256() + rhs.asUint256()).asPrimitive());
    }
}

function subUnderflowing(Primitive lhs, Primitive rhs) pure returns (bool, Primitive) {
    unchecked {
        return (lhs.lt(rhs).asBool(), (lhs.asUint256() - rhs.asUint256()).asPrimitive());
    }
}

function mulOverflowing(Primitive lhs, Primitive rhs) pure returns (bool, Primitive) {
    unchecked {
        return (lhs.gt(Constants.ZERO).and(rhs.gt(Constants.MAX / lhs)).asBool(), (lhs.asUint256() * rhs.asUint256()).asPrimitive());
    }
}

function divByAny(Primitive lhs, Primitive rhs) pure returns (bool, Primitive) {
    unchecked {
        return (rhs.asUint256() == 0, (lhs.asUint256() / rhs.asUint256()).asPrimitive());
    }
}

function modByAny(Primitive lhs, Primitive rhs) pure returns (bool, Primitive) {
    unchecked {
        return (rhs.asUint256() == 0, (lhs.asUint256() % rhs.asUint256()).asPrimitive());
    }
}

function signedDivByAny(Primitive lhs, Primitive rhs) pure returns (bool, Primitive) {
    unchecked {
        return (rhs.asUint256() == 0, (lhs.asInt256() / rhs.asInt256()).asPrimitive());
    }
}

function signedModByAny(Primitive lhs, Primitive rhs) pure returns (bool, Primitive) {
    unchecked {
        return (rhs.asUint256() == 0, (lhs.asInt256() % rhs.asInt256()).asPrimitive());
    }
}

function isZero(Primitive self) pure returns (Primitive) {
    return (self.asUint256() == 0).asPrimitive();
}

function extendSign(Primitive self, Primitive bits) pure returns (Primitive result) {
    if (bits.gt(Constants.BIT_SIZE).asBool()) revert Error.Overflow();
    assembly {
        result := signextend(div(bits, 8), self)
    }
}
