// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {Constants as PrimitiveConstants} from "src/primitive/Constants.sol";
import {SmartPointer, LibSmartPointer} from "src/smart-pointer/SmartPointer.sol";
import {Members, LibMembers} from "src/option/Members.sol";
import {Constants} from "src/option/Constants.sol";
import {Error} from "src/option/Error.sol";

// option metadata layout
//
// | empty | enum | SmartPointer |
// | ----- | ---- | ------------ |
// | 184   | 8    | 64           |
type Option is uint256;

using LibOption for Option global;
using LibOption for Primitive;

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

    function isSome(Option self) internal pure returns (Primitive) {
        return self.asPrimitive().shr(Constants.ENUM_OFFSET);
    }

    function isNone(Option self) internal pure returns (Primitive) {
        return self.asPrimitive().shr(Constants.ENUM_OFFSET).isZero();
    }

    function expect(Option self, string memory message) internal pure returns (SmartPointer) {
        if (self.isNone().asBool()) revert(message);
        return self.inner();
    }

    function unwrap(Option self) internal pure returns (SmartPointer) {
        if (self.isNone().asBool()) revert Error.IsNone();
        return self.inner();
    }

    function unwrapOr(Option self, SmartPointer defaultValue) internal pure returns (SmartPointer) {
        return self.isSome().asBool() ? self.inner() : defaultValue;
    }

    function unwrapOrElse(
        Option self,
        function() pure returns (SmartPointer) fn
    ) internal pure returns (SmartPointer) {
        return self.isSome().asBool() ? self.inner() : fn();
    }

    function inner(Option self) internal pure returns (SmartPointer) {
        return self.asPrimitive().and(Constants.SMART_POINTER_MASK).asSmartPointer();
    }

    function asPrimitive(Option self) internal pure returns (Primitive) {
        return Primitive.wrap(Option.unwrap(self));
    }

    function asOption(Primitive self) internal pure returns (Option) {
        return Option.wrap(Primitive.unwrap(self));
    }
}
