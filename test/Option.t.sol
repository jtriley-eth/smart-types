// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "lib/forge-std/src/Test.sol";
import "test/base/PrimitiveAssertions.sol";
import "test/mock/MockOption.sol";

import {Primitive, PrimitiveAs, MemoryPointer, LibMemoryPointer, Option, OptionConstants, OptionError, LibOption} from "src/Prelude.sol";

contract OptionTest is Test, PrimitiveAssertions {
    using LibOption for MemoryPointer;
    using LibOption for Primitive;
    using LibMemoryPointer for Primitive;
    using PrimitiveAs for *;

    MockOption mock;

    function setUp() public {
        mock = new MockOption();
    }

    function testNone() public {
        assertEq(LibOption.None().asPrimitive(), Primitive.wrap(0));
    }

    function testFuzzSome(uint32 ptr) public {
        assertEq(
            LibOption.Some(ptr.asPrimitive().asMemoryPointer()).asPrimitive(),
            ptr.asPrimitive().or(Primitive.wrap(1).shl(OptionConstants.ENUM_OFFSET))
        );
    }

    function testFuzzAsOption(Primitive value) public {
        assertEq(value.asOption().asPrimitive(), value);
    }

    function testFuzzIsSome(uint32 ptr) public {
        assertTrue(LibOption.Some(ptr.asPrimitive().asMemoryPointer()).isSome().asBool());
    }

    function testIsNone() public {
        assertTrue(LibOption.None().isNone().asBool());
    }

    function testFuzzExpect(uint32 ptr, string calldata message) public {
        assertEq(
            LibOption.Some(ptr.asPrimitive().asMemoryPointer()).expect("").asPrimitive(),
            ptr.asPrimitive()
        );
        vm.expectRevert(bytes(message));
        mock.expect(LibOption.None(), message);
    }

    function testFuzzUnwrap(uint32 ptr) public {
        assertEq(
            LibOption.Some(ptr.asPrimitive().asMemoryPointer()).unwrap().asPrimitive(),
            ptr.asPrimitive()
        );
        vm.expectRevert(OptionError.IsNone.selector);
        mock.unwrap(LibOption.None());
    }

    function testFuzzUnwrapOr(uint32 ptr, uint32 defaultPtr) public {
        assertEq(
            LibOption.Some(ptr.asPrimitive().asMemoryPointer())
                .unwrapOr(defaultPtr.asPrimitive().asMemoryPointer())
                .asPrimitive(),
            ptr.asPrimitive()
        );
        assertEq(
            LibOption.None()
                .unwrapOr(defaultPtr.asPrimitive().asMemoryPointer())
                .asPrimitive(),
            defaultPtr.asPrimitive()
        );
    }

    function testFuzzUnwrapOrElse(uint32 ptr) public {
        assertEq(
            LibOption.Some(ptr.asPrimitive().asMemoryPointer())
                .unwrapOrElse(defaultValue)
                .asPrimitive(),
            ptr.asPrimitive()
        );
        assertEq(
            LibOption.None().unwrapOrElse(defaultValue).asPrimitive(),
            defaultValue().asPrimitive()
        );
    }

    function testFuzzUnwrapUnchecked(uint32 ptr) public {
        assertEq(
            LibOption.Some(ptr.asPrimitive().asMemoryPointer()).unwrapUnchecked().asPrimitive(),
            ptr.asPrimitive()
        );
        assertEq(
            LibOption.None().unwrapUnchecked().asPrimitive(),
            Primitive.wrap(0)
        );
    }

    function defaultValue() internal pure returns (MemoryPointer) {
        return MemoryPointer.wrap(1);
    }
}
