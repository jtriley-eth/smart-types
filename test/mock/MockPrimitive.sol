// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/Prelude.sol";

contract MockPrimitive {
    function addChecked(Primitive lhs, Primitive rhs) external pure returns (Primitive) {
        return lhs.addChecked(rhs);
    }

    function subChecked(Primitive lhs, Primitive rhs) external pure returns (Primitive) {
        return lhs.subChecked(rhs);
    }

    function mulChecked(Primitive lhs, Primitive rhs) external pure returns (Primitive) {
        return lhs.mulChecked(rhs);
    }

    function divChecked(Primitive lhs, Primitive rhs) external pure returns (Primitive) {
        return lhs.divChecked(rhs);
    }

    function signedDivChecked(Primitive lhs, Primitive rhs) external pure returns (Primitive) {
        return lhs.signedDivChecked(rhs);
    }

    function modChecked(Primitive lhs, Primitive rhs) external pure returns (Primitive) {
        return lhs.modChecked(rhs);
    }

    function signedModChecked(Primitive lhs, Primitive rhs) external pure returns (Primitive) {
        return lhs.signedModChecked(rhs);
    }

    function addModChecked(Primitive lhs, Primitive rhs, Primitive modulus)
        external
        pure
        returns (Primitive)
    {
        return lhs.addModChecked(rhs, modulus);
    }

    function mulModChecked(Primitive lhs, Primitive rhs, Primitive modulus)
        external
        pure
        returns (Primitive)
    {
        return lhs.mulModChecked(rhs, modulus);
    }

    function constrainBits(Primitive lhs, Primitive rhs) external pure returns (Primitive) {
        return lhs.constrainBits(rhs);
    }
}
