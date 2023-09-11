// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// import {Arg} from "src/fn/Arg.sol";
import {Primitive} from "src/primitive/Primitive.sol";
import {As as PrimitiveAs} from "src/primitive/As.sol";
import {Option, LibOption} from "src/option/Option.sol";
import {LibMemoryPointer} from "src/ptr/MemoryPointer.sol";
import {Constants, Constants as Const} from "src/fn/Constants.sol";
import {Error} from "src/fn/Error.sol";
import {From} from "src/fn/From.sol";

// fn bit metadata
//
// | empty | dest | kindBitmap | appliedArgs | expectedArgs | argPtr |
// | ----- | ---- | ---------- | ----------- | ------------ | ------ |
// | 184   | 16   | 8          | 8           | 8            | 32     |
type Fn is uint256;

using {
    destination,
    kindBitmap,
    appliedArguments,
    expectedArguments,
    argumentsPointer,
    argumentAt,
    argumentAtUnchecked,
    isConcreteAt,
    isFullyApplied,
    isCallable,
    call,
    clone,
    asPrimitive
 } for Fn global;
using LibFn for Fn global;
using LibApply for Fn global;
using From for Fn global;
using LibFn for Primitive;
using LibMemoryPointer for Primitive;
using PrimitiveAs for bool;

library LibFn {
    function toFn(function() pure returns (Primitive) f) internal pure returns (Fn fn) {
        assembly {
            fn := f
        }
        return fn.asPrimitive().shl(Const.DEST_OFFSET).asFn();
    }

    function toFn(function(Primitive) pure returns (Primitive) f) internal pure returns (Fn fn) {
        Primitive dest;
        Primitive argPtr;
        assembly ("memory-safe") {
            dest := f
            argPtr := mload(0x40)
            mstore(0x40, add(argPtr, 0x20))
        }
        return dest
            .shl(Const.DEST_OFFSET)
            .or(Const.ONE.shl(Const.EXPECTED_OFFSET))
            .or(argPtr)
            .asFn();
    }

    function toFn(
        function(Primitive, Primitive) pure returns (Primitive) f
    ) internal pure returns (Fn fn) {
        Primitive dest;
        Primitive argPtr;
        assembly ("memory-safe") {
            dest := f
            argPtr := mload(0x40)
            mstore(0x40, add(argPtr, 0x40))
        }
        return dest
            .shl(Const.DEST_OFFSET)
            .or(Const.TWO.shl(Const.EXPECTED_OFFSET))
            .or(argPtr)
            .asFn();
    }

    function toFn(
        function(Primitive, Primitive, Primitive) pure returns (Primitive) f
    ) internal pure returns (Fn fn) {
        Primitive dest;
        Primitive argPtr;
        assembly ("memory-safe") {
            dest := f
            argPtr := mload(0x40)
            mstore(0x40, add(argPtr, 0x60))
        }
        return dest
            .shl(Const.DEST_OFFSET)
            .or(Const.THREE.shl(Const.EXPECTED_OFFSET))
            .or(argPtr)
            .asFn();
    }

    function toFn(
        function(Primitive, Primitive, Primitive, Primitive) pure returns (Primitive) f
    ) internal pure returns (Fn fn) {
        Primitive dest;
        Primitive argPtr;
        assembly ("memory-safe") {
            dest := f
            argPtr := mload(0x40)
            mstore(0x40, add(argPtr, 0x80))
        }
        return dest
            .shl(Const.DEST_OFFSET)
            .or(Const.FOUR.shl(Const.EXPECTED_OFFSET))
            .or(argPtr)
            .asFn();
    }

    function toFn(
        function(Primitive, Primitive, Primitive, Primitive, Primitive) pure returns (Primitive) f
    ) internal pure returns (Fn fn) {
        Primitive dest;
        Primitive argPtr;
        assembly ("memory-safe") {
            dest := f
            argPtr := mload(0x40)
            mstore(0x40, add(argPtr, 0xa0))
        }
        return dest
            .shl(Const.DEST_OFFSET)
            .or(Const.FIVE.shl(Const.EXPECTED_OFFSET))
            .or(argPtr)
            .asFn();
    }

    function toFn(
        function(
            Primitive,
            Primitive,
            Primitive,
            Primitive,
            Primitive,
            Primitive
        ) pure returns (Primitive) f
    ) internal pure returns (Fn fn) {
        Primitive dest;
        Primitive argPtr;
        assembly ("memory-safe") {
            dest := f
            argPtr := mload(0x40)
            mstore(0x40, add(argPtr, 0xc0))
        }
        return dest
            .shl(Const.DEST_OFFSET)
            .or(Const.SIX.shl(Const.EXPECTED_OFFSET))
            .or(argPtr)
            .asFn();
    }

    function toFn(
        function(
            Primitive,
            Primitive,
            Primitive,
            Primitive,
            Primitive,
            Primitive,
            Primitive
        ) pure returns (Primitive) f
    ) internal pure returns (Fn fn) {
        Primitive dest;
        Primitive argPtr;
        assembly ("memory-safe") {
            dest := f
            argPtr := mload(0x40)
            mstore(0x40, add(argPtr, 0xe0))
        }
        return dest
            .shl(Const.DEST_OFFSET)
            .or(Const.SEVEN.shl(Const.EXPECTED_OFFSET))
            .or(argPtr)
            .asFn();
    }

    function toFn(
        function(
            Primitive,
            Primitive,
            Primitive,
            Primitive,
            Primitive,
            Primitive,
            Primitive,
            Primitive
        ) pure returns (Primitive) f
    ) internal pure returns (Fn fn) {
        Primitive dest;
        Primitive argPtr;
        assembly ("memory-safe") {
            dest := f
            argPtr := mload(0x40)
            mstore(0x40, add(argPtr, 0x0100))
        }
        return dest
            .shl(Const.DEST_OFFSET)
            .or(Const.EIGHT.shl(Const.EXPECTED_OFFSET))
            .or(argPtr)
            .asFn();
    }

    function asFn(Primitive self) internal pure returns (Fn) {
        return Fn.wrap(Primitive.unwrap(self));
    }
}

library LibApply {
    function applyArgument(Fn self, Fn arg) internal pure returns (Fn) {
        Primitive appliedArgs = self.appliedArguments();
        if (appliedArgs.eq(self.expectedArguments()).asBool()) {
            revert Error.ArgOverflow();
        }
        Primitive argPtr = self.argumentsPointer() + (Const.ARG_SIZE * appliedArgs);
        assembly {
            mstore(argPtr, arg)
        }
        return self.asPrimitive()
            .and(Const.KIND_AND_APPLIED_MASK.shl(Const.APPLIED_OFFSET).not())
            .or(self.kindBitmap().shl(Const.KIND_OFFSET + Const.ONE))
            .or(appliedArgs.add(Const.ONE).shl(Const.APPLIED_OFFSET))
            .asFn();
    }

    function applyArgument(Fn self, Primitive arg) internal pure returns (Fn) {
        Primitive appliedArgs = self.appliedArguments();
        if (appliedArgs.eq(self.expectedArguments()).asBool()) {
            revert Error.ArgOverflow();
        }
        Primitive argPtr = self.argumentsPointer() + (Const.ARG_SIZE * appliedArgs);
        assembly {
            mstore(argPtr, arg)
        }
        return self.asPrimitive()
            .and(Const.KIND_AND_APPLIED_MASK.shl(Const.APPLIED_OFFSET).not())
            .or(self.kindBitmap().shl(Const.ONE).or(Const.ONE).shl(Const.KIND_OFFSET))
            .or(appliedArgs.add(Const.ONE).shl(Const.APPLIED_OFFSET))
            .asFn();
    }
}

function destination(Fn self) pure returns (Primitive) {
    return self.asPrimitive().shr(Const.DEST_OFFSET).and(Const.DEST_MASK);
}

function kindBitmap(Fn self) pure returns (Primitive) {
    return self.asPrimitive().shr(Const.KIND_OFFSET).and(Const.KIND_MASK);
}

function appliedArguments(Fn self) pure returns (Primitive) {
    return self.asPrimitive().shr(Const.APPLIED_OFFSET).and(Const.APPLIED_MASK);
}

function expectedArguments(Fn self) pure returns (Primitive) {
    return self.asPrimitive().shr(Const.EXPECTED_OFFSET).and(Const.EXPECTED_MASK);
}

function argumentsPointer(Fn self) pure returns (Primitive) {
    return self.asPrimitive().and(Const.ARG_PTR_MASK);
}

function argumentAt(Fn self, Primitive index) pure returns (Option) {
    if (self.isConcreteAt(index).asBool()) {
        return LibOption.Some(
            self.argumentsPointer().add(index * Const.ARG_SIZE).asMemoryPointer()
        );
    }
    return LibOption.None();
}

function argumentAtUnchecked(Fn self, Primitive index) pure returns (Primitive arg) {
    Primitive argPtr = self.argumentsPointer() + (index * Const.ARG_SIZE);
    assembly {
        arg := mload(argPtr)
    }
}

function isConcreteAt(Fn self, Primitive index) pure returns (Primitive) {
    Primitive maxIndex = self.expectedArguments() - Const.ONE;
    if (index.gt(maxIndex).asBool()) return Const.ZERO;
    return self.asPrimitive()
        .shr(Const.KIND_OFFSET + maxIndex - index)
        .and(Const.ONE);
}

function isFullyApplied(Fn self) pure returns (Primitive) {
    return self.appliedArguments().eq(self.expectedArguments());
}

function isCallable(Fn self) pure returns (Primitive) {
    Primitive expectedBitmap = Const.ONE.shl(self.expectedArguments()).sub(Const.ONE);
    return self.kindBitmap().and(expectedBitmap).eq(expectedBitmap);
}

function call(Fn self) pure returns (Primitive) {
    if (self.isFullyApplied().falsy().asBool()) {
        revert Error.NotFullyApplied();
    }

    Primitive expectedArgs = self.expectedArguments();

    if (self.isCallable().falsy().asBool()) {
        Primitive argsPtr = self.argumentsPointer();
        for (Primitive i; i.lt(expectedArgs).asBool(); i = i.add(Const.ONE)) {
            if (self.isConcreteAt(i).falsy().asBool()) {
                Primitive offset = argsPtr + (i * Const.ARG_SIZE);
                Fn fnToResolve;
                assembly {
                    fnToResolve := mload(offset)
                }
                Primitive result = fnToResolve.call();
                assembly {
                    mstore(offset, result)
                }
            }
        }
    }

    // dont read this
    return __dispatch(self, expectedArgs);
}

function clone(Fn self) pure returns (Fn) {
    Primitive expectedArgs = self.expectedArguments();
    Primitive selfArgsPtr = self.argumentsPointer();
    Primitive newArgsPtr;
    assembly {
        // allocate new memory
        newArgsPtr := mload(0x40)
        mstore(0x40, add(newArgsPtr, shl(5, expectedArgs)))

        // deep clone all Fn arguments
        for { let i } lt(i, expectedArgs) { i := add(i, 1) } {
            let offset := shl(5, i)
            mstore(add(newArgsPtr, offset), mload(add(selfArgsPtr, offset)))
        }
    }
    return self.asPrimitive()
        .and(Const.ARG_PTR_MASK.not())
        .or(newArgsPtr)
        .asFn();
}

function asPrimitive(Fn self) pure returns (Primitive) {
    return Primitive.wrap(Fn.unwrap(self));
}

// i'm warning you
// (these comments were written by copilot, i couldn't bring myself to rm them).
function __dispatch(Fn self, Primitive expectedArgs) pure returns (Primitive) {
    // i'm serious
    if (expectedArgs.eq(Const.ZERO).asBool()) {
        return self.asZeroArgs()();
    }

    // don't do it
    Primitive arg0 = self.argumentAtUnchecked(Const.ZERO);
    if (expectedArgs.eq(Const.ONE).asBool()) {
        return self.asOneArg()(arg0);
    }

    // pls
    Primitive arg1 = self.argumentAtUnchecked(Const.ONE);
    if (expectedArgs.eq(Const.TWO).asBool()) {
        return self.asTwoArgs()(arg0, arg1);
    }

    // i'm begging you
    Primitive arg2 = self.argumentAtUnchecked(Const.TWO);
    if (expectedArgs.eq(Const.THREE).asBool()) {
        return self.asThreeArgs()(arg0, arg1, arg2);
    }

    // i'm on my knees
    Primitive arg3 = self.argumentAtUnchecked(Const.THREE);
    if (expectedArgs.eq(Const.FOUR).asBool()) {
        return self.asFourArgs()(arg0, arg1, arg2, arg3);
    }

    // i'm crying
    Primitive arg4 = self.argumentAtUnchecked(Const.FOUR);
    if (expectedArgs.eq(Const.FIVE).asBool()) {
        return self.asFiveArgs()(arg0, arg1, arg2, arg3, arg4);
    }

    // i'm dying
    Primitive arg5 = self.argumentAtUnchecked(Const.FIVE);
    if (expectedArgs.eq(Const.SIX).asBool()) {
        return self.asSixArgs()(arg0, arg1, arg2, arg3, arg4, arg5);
    }

    // i'm dead
    Primitive arg6 = self.argumentAtUnchecked(Const.SIX);
    if (expectedArgs.eq(Const.SEVEN).asBool()) {
        return self.asSevenArgs()(arg0, arg1, arg2, arg3, arg4, arg5, arg6);
    }

    // i'm in hell
    Primitive arg7 = self.argumentAtUnchecked(Const.SEVEN);
    return self.asEightArgs()(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
}
