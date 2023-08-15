// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {Fn} from "src/fn/Fn.sol";
import {SmartPointer} from "src/smart-pointer/SmartPointer.sol";
import {Vec} from "src/vector/Vec.sol";

library As {
    function asPrimitive(bool self) internal pure returns (Primitive p) {
        assembly ("memory-safe") {
            p := self
        }
    }

    function asPrimitive(address self) internal pure returns(Primitive) {
        return Primitive.wrap(uint160(self));
    }

    function asPrimitive(address payable self) internal pure returns(Primitive) {
        return Primitive.wrap(uint160(address(self)));
    }

    function asPrimitive(uint256 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint248 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint240 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint232 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint224 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint216 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint208 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint200 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint192 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint184 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint176 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint168 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint160 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint152 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint144 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint136 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint128 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint120 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint112 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint104 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint96 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint88 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint80 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint72 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint64 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint56 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint48 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint40 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint32 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint24 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint16 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(uint8 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function asPrimitive(int256 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint256(self));
  }

    function asPrimitive(int248 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint248(self));
    }

    function asPrimitive(int240 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint240(self));
    }

    function asPrimitive(int232 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint232(self));
    }

    function asPrimitive(int224 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint224(self));
    }

    function asPrimitive(int216 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint216(self));
    }

    function asPrimitive(int208 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint208(self));
    }

    function asPrimitive(int200 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint200(self));
    }

    function asPrimitive(int192 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint192(self));
    }

    function asPrimitive(int184 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint184(self));
    }

    function asPrimitive(int176 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint176(self));
    }

    function asPrimitive(int168 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint168(self));
    }

    function asPrimitive(int160 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint160(self));
    }

    function asPrimitive(int152 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint152(self));
    }

    function asPrimitive(int144 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint144(self));
    }

    function asPrimitive(int136 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint136(self));
    }

    function asPrimitive(int128 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint128(self));
    }

    function asPrimitive(int120 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint120(self));
    }

    function asPrimitive(int112 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint112(self));
    }

    function asPrimitive(int104 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint104(self));
    }

    function asPrimitive(int96 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint96(self));
    }

    function asPrimitive(int88 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint88(self));
    }

    function asPrimitive(int80 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint80(self));
    }

    function asPrimitive(int72 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint72(self));
    }

    function asPrimitive(int64 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint64(self));
    }

    function asPrimitive(int56 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint56(self));
    }

    function asPrimitive(int48 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint48(self));
    }

    function asPrimitive(int40 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint40(self));
    }

    function asPrimitive(int32 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint32(self));
    }

    function asPrimitive(int24 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint24(self));
    }

    function asPrimitive(int16 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint16(self));
    }

    function asPrimitive(int8 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint8(self));
    }
}