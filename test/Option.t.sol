// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "lib/forge-std/src/Test.sol";
import "test/base/PrimitiveAssertions.sol";
import "test/mock/MockOption.sol";

import {Primitive, PrimitiveAs, Box, LibBox, Option, OptionConstants, OptionError, LibOption} from "src/Prelude.sol";

contract OptionTest is Test, PrimitiveAssertions {
    using LibOption for Box;
    using LibOption for Primitive;
    using LibBox for Primitive;
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
            LibOption.Some(ptr.asPrimitive().asBox()).asPrimitive(),
            ptr.asPrimitive().or(Primitive.wrap(1).shl(OptionConstants.ENUM_OFFSET))
        );
    }

    function testFuzzAsOption(Primitive value) public {
        assertEq(value.asOption().asPrimitive(), value);
    }

    function testFuzzIsSome(uint64 ptr) public {
        assertTrue(LibOption.Some(ptr.asPrimitive().asBox()).isSome().asBool());
    }

    function testIsNone() public {
        assertTrue(LibOption.None().isNone().asBool());
    }

    function testFuzzExpect(uint64 ptr, string calldata message) public {
        assertEq(
            LibOption.Some(ptr.asPrimitive().asBox()).expect("").asPrimitive(),
            ptr.asPrimitive()
        );
        vm.expectRevert(bytes(message));
        mock.expect(LibOption.None(), message);
    }

    function testFuzzUnwrap(uint64 ptr) public {
        assertEq(
            LibOption.Some(ptr.asPrimitive().asBox()).unwrap().asPrimitive(),
            ptr.asPrimitive()
        );
        vm.expectRevert(OptionError.IsNone.selector);
        mock.unwrap(LibOption.None());
    }

    function testFuzzUnwrapOr(uint64 ptr, uint64 defaultPtr) public {
        assertEq(
            LibOption.Some(ptr.asPrimitive().asBox())
                .unwrapOr(defaultPtr.asPrimitive().asBox())
                .asPrimitive(),
            ptr.asPrimitive()
        );
        assertEq(
            LibOption.None()
                .unwrapOr(defaultPtr.asPrimitive().asBox())
                .asPrimitive(),
            defaultPtr.asPrimitive()
        );
    }

    function testFuzzUnwrapOrElse(uint64 ptr) public {
        assertEq(
            LibOption.Some(ptr.asPrimitive().asBox())
                .unwrapOrElse(defaultValue)
                .asPrimitive(),
            ptr.asPrimitive()
        );
        assertEq(
            LibOption.None().unwrapOrElse(defaultValue).asPrimitive(),
            defaultValue().asPrimitive()
        );
    }

    function defaultValue() internal pure returns (Box) {
        return Box.wrap(1);
    }
}
