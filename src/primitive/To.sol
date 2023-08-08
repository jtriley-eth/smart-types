// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";

library To {
    function toPrimitive(bool self) internal pure returns (Primitive p) {
        assembly ("memory-safe") {
            p := self
        }
    }

    function toPrimitive(address self) internal pure returns(Primitive) {
        return Primitive.wrap(uint160(self));
    }

    function toPrimitive(address payable self) internal pure returns(Primitive) {
        return Primitive.wrap(uint160(address(self)));
    }

    function toPrimitive(uint256 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint248 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint240 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint232 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint224 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint216 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint208 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint200 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint192 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint184 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint176 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint168 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint160 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint152 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint144 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint136 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint128 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint120 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint112 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint104 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint96 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint88 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint80 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint72 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint64 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint56 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint48 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint40 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint32 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint24 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint16 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(uint8 self) internal pure returns (Primitive) {
        return Primitive.wrap(self);
    }

    function toPrimitive(int256 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint256(self));
  }

    function toPrimitive(int248 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint248(self));
    }

    function toPrimitive(int240 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint240(self));
    }

    function toPrimitive(int232 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint232(self));
    }

    function toPrimitive(int224 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint224(self));
    }

    function toPrimitive(int216 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint216(self));
    }

    function toPrimitive(int208 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint208(self));
    }

    function toPrimitive(int200 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint200(self));
    }

    function toPrimitive(int192 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint192(self));
    }

    function toPrimitive(int184 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint184(self));
    }

    function toPrimitive(int176 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint176(self));
    }

    function toPrimitive(int168 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint168(self));
    }

    function toPrimitive(int160 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint160(self));
    }

    function toPrimitive(int152 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint152(self));
    }

    function toPrimitive(int144 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint144(self));
    }

    function toPrimitive(int136 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint136(self));
    }

    function toPrimitive(int128 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint128(self));
    }

    function toPrimitive(int120 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint120(self));
    }

    function toPrimitive(int112 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint112(self));
    }

    function toPrimitive(int104 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint104(self));
    }

    function toPrimitive(int96 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint96(self));
    }

    function toPrimitive(int88 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint88(self));
    }

    function toPrimitive(int80 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint80(self));
    }

    function toPrimitive(int72 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint72(self));
    }

    function toPrimitive(int64 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint64(self));
    }

    function toPrimitive(int56 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint56(self));
    }

    function toPrimitive(int48 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint48(self));
    }

    function toPrimitive(int40 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint40(self));
    }

    function toPrimitive(int32 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint32(self));
    }

    function toPrimitive(int24 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint24(self));
    }

    function toPrimitive(int16 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint16(self));
    }

    function toPrimitive(int8 self) internal pure returns (Primitive) {
        return Primitive.wrap(uint8(self));
    }
}