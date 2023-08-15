// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "lib/forge-std/src/Test.sol";
import "test/base/PrimitiveAssertions.sol";

import {Primitive, PrimitiveConstants, PrimitiveAs, PrimitiveError} from "src/Prelude.sol";

contract PrimitiveTest is Test, PrimitiveAssertions {
    using PrimitiveAs for uint256;

    function testFuzzEq(Primitive lhs, Primitive rhs) public {
        if (lhs.eq(rhs).asBool()) {
            assertFalse(lhs.neq(rhs));
            assertEq(lhs, rhs);
        }
    }

    function testFuzzNeq(Primitive lhs, Primitive rhs) public {
        if (lhs.neq(rhs).asBool()) {
            assertFalse(lhs.eq(rhs));
            assertNotEq(lhs, rhs);
        }
    }

    function testFuzzGt(Primitive lhs, Primitive rhs) public {
        if (lhs.gt(rhs).asBool()) {
            assertGt(lhs, rhs);
        }
    }

    function testFuzzSignedGt(Primitive lhs, Primitive rhs) public {
        if (lhs.signedGt(rhs).asBool()) {
            assertSignedGt(lhs, rhs);
        }
    }

    function testFuzzLt(Primitive lhs, Primitive rhs) public {
        if (lhs.lt(rhs).asBool()) {
            assertLt(lhs, rhs);
        }
    }

    function testFuzzSignedLt(Primitive lhs, Primitive rhs) public {
        if (lhs.signedLt(rhs).asBool()) {
            assertSignedLt(lhs, rhs);
        }
    }

    function testFuzzAdd(Primitive lhs, Primitive rhs) public {
        unchecked {
            assertEq(lhs.add(rhs).asUint256(), lhs.asUint256() + rhs.asUint256());
        }
    }

    function testFuzzSub(Primitive lhs, Primitive rhs) public {
        unchecked {
            assertEq(lhs.sub(rhs).asUint256(), lhs.asUint256() - rhs.asUint256());
        }
    }
}
