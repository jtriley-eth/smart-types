// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ArgKind} from "src/fn/ArgKind.sol";
import {Constants as Const} from "src/fn/Constants.sol";
import {Fn, LibFn} from "src/fn/Fn.sol";
import {Primitive} from "src/primitive/Primitive.sol";
import {As as PrimitiveAs} from "src/primitive/As.sol";
import {SmartPointer, LibSmartPointer} from "src/smart-pointer/SmartPointer.sol";

// arg bit metadata
//
// | empty | ArgKind | SmartPointer or Fn |
// | ----- | ------- | ------------------ |
// | 184   | 8       | 72                 |
type Arg is uint256;

using {
    isFunction,
    isConcrete,
    inner,
    asPrimitive
} for Arg global;
using LibArg for Arg global;
using PrimitiveAs for Fn;
using LibArg for Primitive;
using LibFn for Primitive;
using LibSmartPointer for Primitive;

library LibArg {
    function Function(Fn fn) internal pure returns (Arg) {
        return fn.asPrimitive().asArg();
    }

    function Concrete(SmartPointer smartPointer) internal pure returns (Arg) {
        return smartPointer.asPrimitive()
            .or(ArgKind.Concrete.asPrimitive().shl(Const.ARG_KIND_OFFSET))
            .asArg();
    }

    function asArg(Primitive self) internal pure returns (Arg) {
        return Arg.wrap(Primitive.unwrap(self));
    }
}

function isFunction(Arg self) pure returns (Primitive) {
    return self.isConcrete().falsy();
}

function isConcrete(Arg self) pure returns (Primitive) {
    return self.asPrimitive()
        .shr(Const.ARG_KIND_OFFSET)
        .and(Const.ARG_KIND_MASK);
}

function inner(Arg self) pure returns (Primitive) {
    return self.asPrimitive().and(Const.ARG_INNER_MASK);
}

function asPrimitive(Arg self) pure returns (Primitive) {
    return Primitive.wrap(Arg.unwrap(self));
}
