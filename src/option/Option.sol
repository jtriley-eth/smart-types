// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {SmartPointer, LibSmartPointer} from "src/smart-pointer/SmartPointer.sol";
import {Members} from "src/option/Members.sol";
import {Constants} from "src/option/Constants.sol";
import {Error} from "src/option/Error.sol";

// option metadata layout
//
// | empty | enum | SmartPointer |
// | ----- | ---- | ------------ |
// | 184   | 8    | 64           |
type Option is uint256;

using {
    isSome,
    isNone,
    expect,
    unwrap,
    unwrapOr,
    unwrapOrElse,
    asPrimitive
} for Option global;
using LibOption for Option global;
using LibOption for Primitive;
using LibSmartPointer for Primitive;

library LibOption {
    function None() internal pure returns (Option) {
        return Option.wrap(0);
    }

    function Some(SmartPointer ptr) internal pure returns (Option) {
        return Members.Some.asPrimitive()
            .shl(Constants.ENUM_OFFSET)
            .or(ptr.asPrimitive())
            .asOption();
    }

    function asOption(Primitive self) internal pure returns (Option) {
        return Option.wrap(self.asUint256());
    }
}

function isSome(Option self) pure returns (Primitive) {
    return self.asPrimitive()
        .shr(Constants.ENUM_OFFSET)
        .and(Constants.ENUM_MASK);
}

function isNone(Option self) pure returns (Primitive) {
    return self.asPrimitive()
        .shr(Constants.ENUM_OFFSET)
        .and(Constants.ENUM_MASK);
}

function expect(Option self, string memory message) pure returns (SmartPointer) {
    if (self.isNone().asBool()) revert(message);
    return self.asPrimitive()
        .and(Constants.SMART_POINTER_MASK)
        .asSmartPointer();
}

function unwrap(Option self) pure returns (SmartPointer) {
    if (self.isNone().asBool()) revert Error.IsNone();
    return self.asPrimitive()
        .and(Constants.SMART_POINTER_MASK)
        .asSmartPointer();
}

function unwrapOr(Option self, SmartPointer defaultValue) pure returns (SmartPointer) {
    return self.isSome().asBool()
        ? self.asPrimitive().and(Constants.SMART_POINTER_MASK).asSmartPointer()
        : defaultValue;
}

function unwrapOrElse(
    Option self,
    function() pure returns (SmartPointer) fn
) pure returns (SmartPointer) {
    return self.isSome().asBool()
        ? self.asPrimitive().and(Constants.SMART_POINTER_MASK).asSmartPointer()
        : fn();
}

function asPrimitive(Option self) pure returns (Primitive) {
    return Primitive.wrap(Option.unwrap(self));
}
