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

function neq(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.asUint256() != rhs.asUint256()).asPrimitive();
}

function gt(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.asUint256() > rhs.asUint256()).asPrimitive();
}

function signedGt(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.asInt256() > rhs.asInt256()).asPrimitive();
}

function lt(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.asUint256() < rhs.asUint256()).asPrimitive();
}

function signedLt(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    return (lhs.asInt256() < rhs.asInt256()).asPrimitive();
}

function add(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    unchecked {
        return (lhs.asUint256() + rhs.asUint256()).asPrimitive();
    }
}

function addChecked(Primitive lhs, Primitive rhs) pure returns (Primitive res) {
    unchecked {
        res = lhs.add(rhs);
        if (res.lt(lhs).asBool()) revert Error.Overflow();
    }
}

function sub(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    unchecked {
        return (lhs.asUint256() - rhs.asUint256()).asPrimitive();
    }
}

function subChecked(Primitive lhs, Primitive rhs) pure returns (Primitive res) {
    unchecked {
        res = lhs.sub(rhs);
        if (res.gt(lhs).asBool()) revert Error.Underflow();
    }
}

function mul(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    unchecked {
        return (lhs.asUint256() * rhs.asUint256()).asPrimitive();
    }
}

function mulChecked(Primitive lhs, Primitive rhs) pure returns (Primitive res) {
    unchecked {
        res = lhs.mul(rhs);
        if (res.div(rhs).neq(lhs).asBool()) revert Error.Overflow();
    }
}

function div(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    unchecked {
        return (lhs.asUint256() / rhs.asUint256()).asPrimitive();
    }
}

function divChecked(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    unchecked {
        if (rhs.isZero().asBool()) revert Error.DivisionByZero();
        return lhs.div(rhs);
    }
}

function signedDiv(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    unchecked {
        return (lhs.asInt256() / rhs.asInt256()).asPrimitive();
    }
}

function signedDivChecked(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    unchecked {
        if (rhs.isZero().asBool()) revert Error.DivisionByZero();
        return lhs.signedDiv(rhs);
    }
}

function mod(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    unchecked {
        return (lhs.asUint256() % rhs.asUint256()).asPrimitive();
    }
}

function modChecked(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    unchecked {
        if (rhs.isZero().asBool()) revert Error.DivisionByZero();
        return lhs.mod(rhs);
    }
}

function signedMod(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    unchecked {
        return (lhs.asInt256() % rhs.asInt256()).asPrimitive();
    }
}

function signedModChecked(Primitive lhs, Primitive rhs) pure returns (Primitive) {
    unchecked {
        if (rhs.isZero().asBool()) revert Error.DivisionByZero();
        return lhs.signedMod(rhs);
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
