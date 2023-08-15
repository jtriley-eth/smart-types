// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Primitive} from "src/Prelude.sol";
import {StdAssertions} from "lib/forge-std/src/StdAssertions.sol";

contract PrimitiveAssertions is StdAssertions {
    function assertEq(Primitive lhs, Primitive rhs) internal {
        assertEq(lhs.asUint256(), rhs.asUint256());
    }

    function assertNotEq(Primitive lhs, Primitive rhs) internal {
        assertNotEq(lhs.asUint256(), rhs.asUint256());
    }

    function assertGt(Primitive lhs, Primitive rhs) internal {
        assertGt(lhs.asUint256(), rhs.asUint256());
    }

    function assertGe(Primitive lhs, Primitive rhs) internal {
        assertGe(lhs.asUint256(), rhs.asUint256());
    }

    function assertSignedGt(Primitive lhs, Primitive rhs) internal {
        assertGt(lhs.asInt256(), rhs.asInt256());
    }

    function assertSignedGe(Primitive lhs, Primitive rhs) internal {
        assertGe(lhs.asInt256(), rhs.asInt256());
    }

    function assertLt(Primitive lhs, Primitive rhs) internal {
        assertLt(lhs.asUint256(), rhs.asUint256());
    }

    function assertLe(Primitive lhs, Primitive rhs) internal {
        assertLe(lhs.asUint256(), rhs.asUint256());
    }

    function assertSignedLt(Primitive lhs, Primitive rhs) internal {
        assertLt(lhs.asInt256(), rhs.asInt256());
    }

    function assertSignedLe(Primitive lhs, Primitive rhs) internal {
        assertLe(lhs.asInt256(), rhs.asInt256());
    }

    function assertTrue(Primitive value) internal {
        assertTrue(value.asBool());
    }

    function assertFalse(Primitive value) internal {
        assertFalse(value.asBool());
    }
}
