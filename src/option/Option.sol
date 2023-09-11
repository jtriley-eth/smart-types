// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {MemoryPointer, LibMemoryPointer} from "src/ptr/MemoryPointer.sol";
import {Members} from "src/option/Members.sol";
import {Constants} from "src/option/Constants.sol";
import {Error} from "src/option/Error.sol";

// option metadata layout
//
// | empty | enum | MemoryPointer |
// | ----- | ---- | ------------- |
// | 184   | 8    | 32            |
type Option is uint256;

using {
    isSome,
    isNone,
    expect,
    unwrap,
    unwrapOr,
    unwrapOrElse,
    unwrapUnchecked,
    asPrimitive
} for Option global;
using LibOption for Option global;
using LibOption for Primitive;
using LibMemoryPointer for Primitive;

library LibOption {
    function None() internal pure returns (Option) {
        return Option.wrap(0);
    }

    function Some(MemoryPointer ptr) internal pure returns (Option) {
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
        .and(Constants.ENUM_MASK)
        .isZero();
}

function expect(Option self, string memory message) pure returns (MemoryPointer) {
    if (self.isNone().asBool()) revert(message);
    return self.unwrapUnchecked();
}

function unwrap(Option self) pure returns (MemoryPointer) {
    if (self.isNone().asBool()) revert Error.IsNone();
    return self.unwrapUnchecked();
}

function unwrapOr(Option self, MemoryPointer defaultValue) pure returns (MemoryPointer) {
    return self.isSome().asBool() ? self.unwrapUnchecked() : defaultValue;
}

function unwrapOrElse(
    Option self,
    function() pure returns (MemoryPointer) fn
) pure returns (MemoryPointer) {
    return self.isSome().asBool() ? self.unwrapUnchecked() : fn();
}

function unwrapUnchecked(Option self) pure returns (MemoryPointer) {
    return self.asPrimitive()
        .and(Constants.PTR_MASK)
        .asMemoryPointer();
}

function asPrimitive(Option self) pure returns (Primitive) {
    return Primitive.wrap(Option.unwrap(self));
}
