// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "lib/forge-std/src/Test.sol";
import "test/base/PrimitiveAssertions.sol";
import {Primitive, PrimitiveAs, MemoryPointer, LibMemoryPointer, Fn, LibFn, FnConstants, FnError} from "src/Prelude.sol";

contract FnTest is Test, PrimitiveAssertions {
    using PrimitiveAs for *;
    using LibFn for *;
    using LibMemoryPointer for Primitive;

    function testFuzzToFnZeroArg(uint16 mockDest) public {
        function() pure returns (Primitive) f;
        assembly { f := mockDest }

        assertEq(
            f.toFn().asPrimitive(),
            Primitive.wrap(mockDest).shl(FnConstants.DEST_OFFSET)
        );
    }

    function testFuzzToFnOneArg(uint16 mockDest) public {
        function(Primitive) pure returns (Primitive) f;
        assembly { f := mockDest }

        Fn fn = f.toFn();
        assertEq(
            fn.asPrimitive(),
            Primitive.wrap(mockDest).shl(FnConstants.DEST_OFFSET)
                .or(FnConstants.ONE.shl(FnConstants.EXPECTED_OFFSET))
                .or(fn.argumentsPointer())
        );
    }

    function testFuzzToFnTwoArg(uint16 mockDest) public {
        function(Primitive, Primitive) pure returns (Primitive) f;
        assembly { f := mockDest }

        Fn fn = f.toFn();
        assertEq(
            fn.asPrimitive(),
            Primitive.wrap(mockDest).shl(FnConstants.DEST_OFFSET)
                .or(FnConstants.TWO.shl(FnConstants.EXPECTED_OFFSET))
                .or(fn.argumentsPointer())
        );
    }

    function testFuzzToFnThreeArg(uint16 mockDest) public {
        function(Primitive, Primitive, Primitive) pure returns (Primitive) f;
        assembly { f := mockDest }

        Fn fn = f.toFn();
        assertEq(
            fn.asPrimitive(),
            Primitive.wrap(mockDest).shl(FnConstants.DEST_OFFSET)
                .or(FnConstants.THREE.shl(FnConstants.EXPECTED_OFFSET))
                .or(fn.argumentsPointer())
        );
    }

    function testFuzzToFnFourArg(uint16 mockDest) public {
        function(Primitive, Primitive, Primitive, Primitive) pure returns (Primitive) f;
        assembly { f := mockDest }

        Fn fn = f.toFn();
        assertEq(
            fn.asPrimitive(),
            Primitive.wrap(mockDest).shl(FnConstants.DEST_OFFSET)
                .or(FnConstants.FOUR.shl(FnConstants.EXPECTED_OFFSET))
                .or(fn.argumentsPointer())
        );
    }

    function testFuzzToFnFiveArg(uint16 mockDest) public {
        function(Primitive, Primitive, Primitive, Primitive, Primitive) pure returns (Primitive) f;
        assembly { f := mockDest }

        Fn fn = f.toFn();
        assertEq(
            fn.asPrimitive(),
            Primitive.wrap(mockDest).shl(FnConstants.DEST_OFFSET)
                .or(FnConstants.FIVE.shl(FnConstants.EXPECTED_OFFSET))
                .or(fn.argumentsPointer())
        );
    }

    function testFuzzToFnSixArg(uint16 mockDest) public {
        function(Primitive, Primitive, Primitive, Primitive, Primitive, Primitive) pure returns (Primitive) f;
        assembly { f := mockDest }

        Fn fn = f.toFn();
        assertEq(
            fn.asPrimitive(),
            Primitive.wrap(mockDest).shl(FnConstants.DEST_OFFSET)
                .or(FnConstants.SIX.shl(FnConstants.EXPECTED_OFFSET))
                .or(fn.argumentsPointer())
        );
    }

    function testFuzzToFnSevenArg(uint16 mockDest) public {
        function(Primitive, Primitive, Primitive, Primitive, Primitive, Primitive, Primitive) pure returns (Primitive) f;
        assembly { f := mockDest }

        Fn fn = f.toFn();
        assertEq(
            fn.asPrimitive(),
            Primitive.wrap(mockDest).shl(FnConstants.DEST_OFFSET)
                .or(FnConstants.SEVEN.shl(FnConstants.EXPECTED_OFFSET))
                .or(fn.argumentsPointer())
        );
    }

    function testFuzzToFnEightArg(uint16 mockDest) public {
        function(Primitive, Primitive, Primitive, Primitive, Primitive, Primitive, Primitive, Primitive) pure returns (Primitive) f;
        assembly { f := mockDest }

        Fn fn = f.toFn();
        assertEq(
            fn.asPrimitive(),
            Primitive.wrap(mockDest).shl(FnConstants.DEST_OFFSET)
                .or(FnConstants.EIGHT.shl(FnConstants.EXPECTED_OFFSET))
                .or(fn.argumentsPointer())
        );
    }

    function testFuzzAsFn(Primitive fn) public {
        assertEq(fn, fn.asFn().asPrimitive());
    }

    function testFuzzDestination(Fn fn) public {
        assertEq(
            fn.destination(),
            fn.asPrimitive()
                .shr(FnConstants.DEST_OFFSET)
                .and(FnConstants.DEST_MASK)
        );
    }

    function testFuzzKindBitmap(Fn fn) public {
        assertEq(
            fn.kindBitmap(),
            fn.asPrimitive()
                .shr(FnConstants.KIND_OFFSET)
                .and(FnConstants.KIND_MASK)
        );
    }

    function testFuzzAppliedArguments(Fn fn) public {
        assertEq(
            fn.appliedArguments(),
            fn.asPrimitive()
                .shr(FnConstants.APPLIED_OFFSET)
                .and(FnConstants.APPLIED_MASK)
        );
    }

    function testFuzzExpectedArguments(Fn fn) public {
        assertEq(
            fn.expectedArguments(),
            fn.asPrimitive()
                .shr(FnConstants.EXPECTED_OFFSET)
                .and(FnConstants.EXPECTED_MASK)
        );
    }

    function testFuzzArgumentsPointer(Fn fn) public {
        assertEq(
            fn.argumentsPointer(),
            fn.asPrimitive().and(FnConstants.ARG_PTR_MASK)
        );
    }

    function testFuzzArgumentAtArbitrary(Fn fn, Primitive index) public {
        index = bound(index.asUint256(), 0, 255).asPrimitive();
        if (fn.isConcreteAt(index).asBool()) {
            assertTrue(fn.argumentAt(index).isSome());
        } else {
            assertTrue(fn.argumentAt(index).isNone());
        }
    }

    function testFuzzArgumentAt(Primitive argCount, Primitive index) public {
        Fn fn = __applyAll(__selectFn(argCount));
        if (index.lt(fn.expectedArguments()).asBool()) {
            assertTrue(fn.argumentAt(index).isSome());
            assertEq(
                fn.argumentAt(index).unwrap().asPrimitive(),
                fn.argumentsPointer().add(index.mul(FnConstants.ARG_SIZE))
            );
            assertEq(
                fn.argumentAt(index).unwrap().read(),
                fn.argumentAtUnchecked(index)
            );
        } else {
            assertTrue(fn.argumentAt(index).isNone());
        }
    }

    function testFuzzArgumentAtUnchecked(Primitive argCount, Primitive index) public {
        Fn fn = __applyAll(__selectFn(argCount));
        index = bound(index.asUint256(), 0, argCount.asUint256()).asPrimitive();

        Primitive underlying;
        Primitive underlyingPtr = fn.argumentsPointer().add(index.mul(FnConstants.ARG_SIZE));
        assembly { underlying := mload(underlyingPtr) }

        assertEq(fn.argumentAtUnchecked(index), underlying);
    }

    function testFuzzIsConcreteAt(Primitive argCount, Primitive index) public {
        Fn fn = __selectFn(argCount);
        index = bound(index.asUint256(), 0, argCount.asUint256()).asPrimitive();

        for (uint256 i; i < fn.expectedArguments().asUint256(); i++) {
            assertEq(
                fn.isConcreteAt(i.asPrimitive()).asBool(),
                false
            );
        }

        fn = __applyAll(fn);

        for (uint256 i; i < fn.expectedArguments().asUint256(); i++) {
            assertEq(
                fn.isConcreteAt(i.asPrimitive()).asBool(),
                true
            );
        }
    }

    function testFuzzIsFullyApplied(Primitive argCount) public {
        Fn fn = __selectFn(argCount);

        for (uint256 i; i < fn.expectedArguments().asUint256(); i++) {
            assertFalse(fn.isFullyApplied().asBool());
            fn = fn.applyArgument(Primitive.wrap(i));
        }

        assertTrue(fn.isFullyApplied().asBool());
    }

    function testFuzzIsCallable(Primitive argCount) public {
        Fn fn = __selectFn(argCount);

        for (uint256 i; i < fn.expectedArguments().asUint256(); i++) {
            assertFalse(fn.isCallable().asBool());
            fn = fn.applyArgument(Primitive.wrap(i));
        }

        assertTrue(fn.isCallable().asBool());
    }

    function testFuzzCall(Primitive argCount) public {
        argCount = bound(argCount.asUint256(), 0, 8).asPrimitive();
        Fn fn = __applyAll(__selectFn(argCount));
        Primitive result = fn.call();
        Primitive[9] memory answers = [
            Primitive.wrap(69),
            Primitive.wrap(2),
            Primitive.wrap(3),
            Primitive.wrap(6),
            Primitive.wrap(10),
            Primitive.wrap(15),
            Primitive.wrap(21),
            Primitive.wrap(28),
            Primitive.wrap(36)
        ];

        console.log(fn.argumentAtUnchecked(Primitive.wrap(0)).asUint256());
        console.log(fn.argumentAtUnchecked(Primitive.wrap(1)).asUint256());
        console.log(fn.argumentAtUnchecked(Primitive.wrap(2)).asUint256());
        console.log(fn.argumentAtUnchecked(Primitive.wrap(3)).asUint256());
        console.log(fn.argumentAtUnchecked(Primitive.wrap(4)).asUint256());

        assertEq(result, answers[argCount.asUint256()]);
    }

    function testFuzzClone(Primitive argCount) public {
        Fn fn = __applyAll(__selectFn(argCount));
        Fn newFn = fn.clone();

        assertEq(newFn.destination(), fn.destination());
        assertEq(newFn.kindBitmap(), fn.kindBitmap());
        assertEq(newFn.appliedArguments(), fn.appliedArguments());
        assertEq(newFn.expectedArguments(), fn.expectedArguments());
        assertNotEq(newFn.argumentsPointer(), fn.argumentsPointer());
    }

    function testCallPartiallyApplied() public {
        Fn plus = __add.toFn();

        assertEq(plus.kindBitmap(), FnConstants.ZERO);
        assertEq(plus.appliedArguments(), FnConstants.ZERO);
        assertEq(plus.expectedArguments(), FnConstants.TWO);

        Fn plusOne = plus.clone().applyArgument(FnConstants.ONE);

        assertEq(plusOne.destination(), plus.destination());
        assertEq(plusOne.kindBitmap(), FnConstants.ONE);
        assertEq(plusOne.appliedArguments(), FnConstants.ONE);
        assertEq(plusOne.expectedArguments(), FnConstants.TWO);
        assertNotEq(plusOne.argumentsPointer(), plus.argumentsPointer());

        Fn onePlusOne = plusOne.clone().applyArgument(FnConstants.ONE);

        assertEq(onePlusOne.destination(), plus.destination());
        assertEq(onePlusOne.kindBitmap(), FnConstants.THREE);
        assertEq(onePlusOne.appliedArguments(), FnConstants.TWO);
        assertEq(onePlusOne.expectedArguments(), FnConstants.TWO);

        Primitive result = onePlusOne.call();

        assertEq(result, plusOne.applyArgument(FnConstants.ONE).call());
        assertEq(
            result,
            plus.applyArgument(FnConstants.ONE).applyArgument(FnConstants.ONE).call()
        );
    }

    function testCallCurrysHell() public {
        Fn plusTwo = __add.toFn().applyArgument(FnConstants.TWO);
        Fn double = __mul.toFn().applyArgument(FnConstants.TWO);
        Fn triple = __mul.toFn().applyArgument(FnConstants.THREE);
        Fn quadruple = __mul.toFn().applyArgument(FnConstants.FOUR);
        Fn currysHell = __mul.toFn()
            .applyArgument(
                double.applyArgument(
                    triple.applyArgument(
                        quadruple.applyArgument(
                            plusTwo.applyArgument(FnConstants.TWO)
                        )
                    )
                )
            )
            .applyArgument(FnConstants.THREE);

        Primitive result = currysHell.call();
        Primitive expected = FnConstants.TWO
            .add(FnConstants.TWO)
            .mul(FnConstants.FOUR)
            .mul(FnConstants.THREE)
            .mul(FnConstants.TWO)
            .mul(FnConstants.THREE);

        assertEq(result, expected);
    }

    function __add(Primitive a, Primitive b) internal pure returns (Primitive) {
        return a + b;
    }

    function __mul(Primitive a, Primitive b) internal pure returns (Primitive) {
        return a * b;
    }

    function __selectFn(Primitive kind) internal view returns (Fn) {
        kind = bound(kind.asUint256(), 0, 8).asPrimitive();
        if (kind.eq(Primitive.wrap(0)).asBool()) return __arg0.toFn();
        if (kind.eq(Primitive.wrap(1)).asBool()) return __arg1.toFn();
        if (kind.eq(Primitive.wrap(2)).asBool()) return __arg2.toFn();
        if (kind.eq(Primitive.wrap(3)).asBool()) return __arg3.toFn();
        if (kind.eq(Primitive.wrap(4)).asBool()) return __arg4.toFn();
        if (kind.eq(Primitive.wrap(5)).asBool()) return __arg5.toFn();
        if (kind.eq(Primitive.wrap(6)).asBool()) return __arg6.toFn();
        if (kind.eq(Primitive.wrap(7)).asBool()) return __arg7.toFn();
        if (kind.eq(Primitive.wrap(8)).asBool()) return __arg8.toFn();
        revert("unreachable");
    }

    function __applyAll(Fn fn) internal pure returns (Fn) {
        if (fn.expectedArguments().eq(FnConstants.ZERO).asBool()) return fn;
        fn = fn.applyArgument(Primitive.wrap(1));
        if (fn.expectedArguments().eq(FnConstants.ONE).asBool()) return fn;
        fn = fn.applyArgument(Primitive.wrap(2));
        if (fn.expectedArguments().eq(FnConstants.TWO).asBool()) return fn;
        fn = fn.applyArgument(Primitive.wrap(3));
        if (fn.expectedArguments().eq(FnConstants.THREE).asBool()) return fn;
        fn = fn.applyArgument(Primitive.wrap(4));
        if (fn.expectedArguments().eq(FnConstants.FOUR).asBool()) return fn;
        fn = fn.applyArgument(Primitive.wrap(5));
        if (fn.expectedArguments().eq(FnConstants.FIVE).asBool()) return fn;
        fn = fn.applyArgument(Primitive.wrap(6));
        if (fn.expectedArguments().eq(FnConstants.SIX).asBool()) return fn;
        fn = fn.applyArgument(Primitive.wrap(7));
        if (fn.expectedArguments().eq(FnConstants.SEVEN).asBool()) return fn;
        fn = fn.applyArgument(Primitive.wrap(8));
        return fn;
    }

    function __arg0() internal pure returns (Primitive) {
        return Primitive.wrap(69);
    }

    function __arg1(Primitive a) internal pure returns (Primitive) {
        return a.add(Primitive.wrap(1));
    }

    function __arg2(Primitive a, Primitive b) internal pure returns (Primitive) {
        return a.add(b);
    }

    function __arg3(Primitive a, Primitive b, Primitive c) internal pure returns (Primitive) {
        return a.add(b).add(c);
    }

    function __arg4(Primitive a, Primitive b, Primitive c, Primitive d) internal pure returns (Primitive) {
        return a.add(b).add(c).add(d);
    }

    function __arg5(Primitive a, Primitive b, Primitive c, Primitive d, Primitive e) internal pure returns (Primitive) {
        return a.add(b).add(c).add(d).add(e);
    }

    function __arg6(Primitive a, Primitive b, Primitive c, Primitive d, Primitive e, Primitive f) internal pure returns (Primitive) {
        return a.add(b).add(c).add(d).add(e).add(f);
    }

    function __arg7(Primitive a, Primitive b, Primitive c, Primitive d, Primitive e, Primitive f, Primitive g) internal pure returns (Primitive) {
        return a.add(b).add(c).add(d).add(e).add(f).add(g);
    }

    function __arg8(Primitive a, Primitive b, Primitive c, Primitive d, Primitive e, Primitive f, Primitive g, Primitive h) internal pure returns (Primitive) {
        return a.add(b).add(c).add(d).add(e).add(f).add(g).add(h);
    }
}
