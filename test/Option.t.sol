// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "lib/forge-std/src/Test.sol";
import "test/base/PrimitiveAssertions.sol";
import "test/mock/MockOption.sol";

import {Primitive, PrimitiveAs, SmartPointer, LibSmartPointer, Option, OptionConstants, OptionError, LibOption} from "src/Prelude.sol";

contract OptionTest is Test, PrimitiveAssertions {
    using LibOption for SmartPointer;
    using LibOption for Primitive;
    using LibSmartPointer for Primitive;
    using PrimitiveAs for *;

    MockOption mock;

    function setUp() public {
        mock = new MockOption();
    }

    function testNone() public {
        assertEq(LibOption.None().asPrimitive(), Primitive.wrap(0));
    }

    function testFuzzSome(uint64 ptr) public {
        assertEq(
            LibOption.Some(ptr.asPrimitive().asSmartPointer()).asPrimitive(),
            ptr.asPrimitive().or(Primitive.wrap(1).shl(OptionConstants.ENUM_OFFSET))
        );
    }

    function testFuzzAsOption(Primitive value) public {
        assertEq(value.asOption().asPrimitive(), value);
    }

    function testFuzzIsSome(uint64 ptr) public {
        assertTrue(LibOption.Some(ptr.asPrimitive().asSmartPointer()).isSome().asBool());
    }

    function testIsNone() public {
        assertTrue(LibOption.None().isNone().asBool());
    }

    function testFuzzExpect(uint64 ptr, string calldata message) public {
        assertEq(
            LibOption.Some(ptr.asPrimitive().asSmartPointer()).expect("").asPrimitive(),
            ptr.asPrimitive()
        );
        vm.expectRevert(bytes(message));
        mock.expect(LibOption.None(), message);
    }

    function testFuzzUnwrap(uint64 ptr) public {
        assertEq(
            LibOption.Some(ptr.asPrimitive().asSmartPointer()).unwrap().asPrimitive(),
            ptr.asPrimitive()
        );
        vm.expectRevert(OptionError.IsNone.selector);
        mock.unwrap(LibOption.None());
    }

    function testFuzzUnwrapOr(uint64 ptr, uint64 defaultPtr) public {
        assertEq(
            LibOption.Some(ptr.asPrimitive().asSmartPointer())
                .unwrapOr(defaultPtr.asPrimitive().asSmartPointer())
                .asPrimitive(),
            ptr.asPrimitive()
        );
        assertEq(
            LibOption.None()
                .unwrapOr(defaultPtr.asPrimitive().asSmartPointer())
                .asPrimitive(),
            defaultPtr.asPrimitive()
        );
    }

    function testFuzzUnwrapOrElse(uint64 ptr) public {
        assertEq(
            LibOption.Some(ptr.asPrimitive().asSmartPointer())
                .unwrapOrElse(defaultValue)
                .asPrimitive(),
            ptr.asPrimitive()
        );
        assertEq(
            LibOption.None().unwrapOrElse(defaultValue).asPrimitive(),
            defaultValue().asPrimitive()
        );
    }

    function defaultValue() internal pure returns (SmartPointer) {
        return SmartPointer.wrap(1);
    }
}
