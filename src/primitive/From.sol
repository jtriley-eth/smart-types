// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {Error} from "src/primitive/Error.sol";

library From {

    function toBool(Primitive self) internal pure returns (bool) {
        _validateBits(self, 1);
        unchecked { return Primitive.unwrap(self) != 0; }
    }

    function toAddress(Primitive self) internal pure returns (address) {
        _validateBits(self, 160);
        unchecked { return address(uint160(Primitive.unwrap(self))); }
    }

    function toAddressPayable(Primitive self) internal pure returns (address payable) {
        _validateBits(self, 160);
        unchecked { return payable(address(uint160(Primitive.unwrap(self)))); }
    }

    function toUint256(Primitive self) internal pure returns (uint256) {
        unchecked { return Primitive.unwrap(self); }
    }

    function toUint248(Primitive self) internal pure returns (uint248) {
        _validateBits(self, 248);
        unchecked { return uint248(Primitive.unwrap(self)); }
    }

    function toUint240(Primitive self) internal pure returns (uint240) {
        _validateBits(self, 240);
        unchecked { return uint240(Primitive.unwrap(self)); }
    }

    function toUint232(Primitive self) internal pure returns (uint232) {
        _validateBits(self, 232);
        unchecked { return uint232(Primitive.unwrap(self)); }
    }

    function toUint224(Primitive self) internal pure returns (uint224) {
        _validateBits(self, 224);
        unchecked { return uint224(Primitive.unwrap(self)); }
    }

    function toUint216(Primitive self) internal pure returns (uint216) {
        _validateBits(self, 216);
        unchecked { return uint216(Primitive.unwrap(self)); }
    }

    function toUint208(Primitive self) internal pure returns (uint208) {
        _validateBits(self, 208);
        unchecked { return uint208(Primitive.unwrap(self)); }
    }

    function toUint200(Primitive self) internal pure returns (uint200) {
        _validateBits(self, 200);
        unchecked { return uint200(Primitive.unwrap(self)); }
    }

    function toUint192(Primitive self) internal pure returns (uint192) {
        _validateBits(self, 192);
        unchecked { return uint192(Primitive.unwrap(self)); }
    }

    function toUint184(Primitive self) internal pure returns (uint184) {
        _validateBits(self, 184);
        unchecked { return uint184(Primitive.unwrap(self)); }
    }

    function toUint176(Primitive self) internal pure returns (uint176) {
        _validateBits(self, 176);
        unchecked { return uint176(Primitive.unwrap(self)); }
    }

    function toUint168(Primitive self) internal pure returns (uint168) {
        _validateBits(self, 168);
        unchecked { return uint168(Primitive.unwrap(self)); }
    }

    function toUint160(Primitive self) internal pure returns (uint160) {
        _validateBits(self, 160);
        unchecked { return uint160(Primitive.unwrap(self)); }
    }

    function toUint152(Primitive self) internal pure returns (uint152) {
        _validateBits(self, 152);
        unchecked { return uint152(Primitive.unwrap(self)); }
    }

    function toUint144(Primitive self) internal pure returns (uint144) {
        _validateBits(self, 144);
        unchecked { return uint144(Primitive.unwrap(self)); }
    }

    function toUint136(Primitive self) internal pure returns (uint136) {
        _validateBits(self, 136);
        unchecked { return uint136(Primitive.unwrap(self)); }
    }

    function toUint128(Primitive self) internal pure returns (uint128) {
        _validateBits(self, 128);
        unchecked { return uint128(Primitive.unwrap(self)); }
    }

    function toUint120(Primitive self) internal pure returns (uint120) {
        _validateBits(self, 120);
        unchecked { return uint120(Primitive.unwrap(self)); }
    }

    function toUint112(Primitive self) internal pure returns (uint112) {
        _validateBits(self, 112);
        unchecked { return uint112(Primitive.unwrap(self)); }
    }

    function toUint104(Primitive self) internal pure returns (uint104) {
        _validateBits(self, 104);
        unchecked { return uint104(Primitive.unwrap(self)); }
    }

    function toUint96(Primitive self) internal pure returns (uint96) {
        _validateBits(self, 96);
        unchecked { return uint96(Primitive.unwrap(self)); }
    }

    function toUint88(Primitive self) internal pure returns (uint88) {
        _validateBits(self, 88);
        unchecked { return uint88(Primitive.unwrap(self)); }
    }

    function toUint80(Primitive self) internal pure returns (uint80) {
        _validateBits(self, 80);
        unchecked { return uint80(Primitive.unwrap(self)); }
    }

    function toUint72(Primitive self) internal pure returns (uint72) {
        _validateBits(self, 72);
        unchecked { return uint72(Primitive.unwrap(self)); }
    }

    function toUint64(Primitive self) internal pure returns (uint64) {
        _validateBits(self, 64);
        unchecked { return uint64(Primitive.unwrap(self)); }
    }

    function toUint56(Primitive self) internal pure returns (uint56) {
        _validateBits(self, 56);
        unchecked { return uint56(Primitive.unwrap(self)); }
    }

    function toUint48(Primitive self) internal pure returns (uint48) {
        _validateBits(self, 48);
        unchecked { return uint48(Primitive.unwrap(self)); }
    }

    function toUint40(Primitive self) internal pure returns (uint40) {
        _validateBits(self, 40);
        unchecked { return uint40(Primitive.unwrap(self)); }
    }

    function toUint32(Primitive self) internal pure returns (uint32) {
        _validateBits(self, 32);
        unchecked { return uint32(Primitive.unwrap(self)); }
    }

    function toUint24(Primitive self) internal pure returns (uint24) {
        _validateBits(self, 24);
        unchecked { return uint24(Primitive.unwrap(self)); }
    }

    function toUint16(Primitive self) internal pure returns (uint16) {
        _validateBits(self, 16);
        unchecked { return uint16(Primitive.unwrap(self)); }
    }

    function toUint8(Primitive self) internal pure returns (uint8) {
        _validateBits(self, 8);
        unchecked { return uint8(Primitive.unwrap(self)); }
    }

    function toInt256(Primitive self) internal pure returns (int256) {
        unchecked { return int256(Primitive.unwrap(self)); }
    }

    function toInt248(Primitive self) internal pure returns (int248) {
        _validateBits(self, 248);
        unchecked { return int248(int256(Primitive.unwrap(self))); }
    }

    function toInt240(Primitive self) internal pure returns (int240) {
        _validateBits(self, 240);
        unchecked { return int240(int256(Primitive.unwrap(self))); }
    }

    function toInt232(Primitive self) internal pure returns (int232) {
        _validateBits(self, 232);
        unchecked { return int232(int256(Primitive.unwrap(self))); }
    }

    function toInt224(Primitive self) internal pure returns (int224) {
        _validateBits(self, 224);
        unchecked { return int224(int256(Primitive.unwrap(self))); }
    }

    function toInt216(Primitive self) internal pure returns (int216) {
        _validateBits(self, 216);
        unchecked { return int216(int256(Primitive.unwrap(self))); }
    }

    function toInt208(Primitive self) internal pure returns (int208) {
        _validateBits(self, 208);
        unchecked { return int208(int256(Primitive.unwrap(self))); }
    }

    function toInt200(Primitive self) internal pure returns (int200) {
        _validateBits(self, 200);
        unchecked { return int200(int256(Primitive.unwrap(self))); }
    }

    function toInt192(Primitive self) internal pure returns (int192) {
        _validateBits(self, 192);
        unchecked { return int192(int256(Primitive.unwrap(self))); }
    }

    function toInt184(Primitive self) internal pure returns (int184) {
        _validateBits(self, 184);
        unchecked { return int184(int256(Primitive.unwrap(self))); }
    }

    function toInt176(Primitive self) internal pure returns (int176) {
        _validateBits(self, 176);
        unchecked { return int176(int256(Primitive.unwrap(self))); }
    }

    function toInt168(Primitive self) internal pure returns (int168) {
        _validateBits(self, 168);
        unchecked { return int168(int256(Primitive.unwrap(self))); }
    }

    function toInt160(Primitive self) internal pure returns (int160) {
        _validateBits(self, 160);
        unchecked { return int160(int256(Primitive.unwrap(self))); }
    }

    function toInt152(Primitive self) internal pure returns (int152) {
        _validateBits(self, 152);
        unchecked { return int152(int256(Primitive.unwrap(self))); }
    }

    function toInt144(Primitive self) internal pure returns (int144) {
        _validateBits(self, 144);
        unchecked { return int144(int256(Primitive.unwrap(self))); }
    }

    function toInt136(Primitive self) internal pure returns (int136) {
        _validateBits(self, 136);
        unchecked { return int136(int256(Primitive.unwrap(self))); }
    }

    function toInt128(Primitive self) internal pure returns (int128) {
        _validateBits(self, 128);
        unchecked { return int128(int256(Primitive.unwrap(self))); }
    }

    function toInt120(Primitive self) internal pure returns (int120) {
        _validateBits(self, 120);
        unchecked { return int120(int256(Primitive.unwrap(self))); }
    }

    function toInt112(Primitive self) internal pure returns (int112) {
        _validateBits(self, 112);
        unchecked { return int112(int256(Primitive.unwrap(self))); }
    }

    function toInt104(Primitive self) internal pure returns (int104) {
        _validateBits(self, 104);
        unchecked { return int104(int256(Primitive.unwrap(self))); }
    }

    function toInt96(Primitive self) internal pure returns (int96) {
        _validateBits(self, 96);
        unchecked { return int96(int256(Primitive.unwrap(self))); }
    }

    function toInt88(Primitive self) internal pure returns (int88) {
        _validateBits(self, 88);
        unchecked { return int88(int256(Primitive.unwrap(self))); }
    }

    function toInt80(Primitive self) internal pure returns (int80) {
        _validateBits(self, 80);
        unchecked { return int80(int256(Primitive.unwrap(self))); }
    }

    function toInt72(Primitive self) internal pure returns (int72) {
        _validateBits(self, 72);
        unchecked { return int72(int256(Primitive.unwrap(self))); }
    }

    function toInt64(Primitive self) internal pure returns (int64) {
        _validateBits(self, 64);
        unchecked { return int64(int256(Primitive.unwrap(self))); }
    }

    function toInt32(Primitive self) internal pure returns (int32) {
        _validateBits(self, 32);
        unchecked { return int32(int256(Primitive.unwrap(self))); }
    }

    function toInt24(Primitive self) internal pure returns (int24) {
        _validateBits(self, 24);
        unchecked { return int24(int256(Primitive.unwrap(self))); }
    }

    function toInt16(Primitive self) internal pure returns (int16) {
        _validateBits(self, 16);
        unchecked { return int16(int256(Primitive.unwrap(self))); }
    }

    function toInt8(Primitive self) internal pure returns (int8) {
        _validateBits(self, 8);
        unchecked { return int8(int256(Primitive.unwrap(self))); }
    }

    function _validateBits(Primitive self, uint256 bits) private pure {
        if (Primitive.unwrap(self) >> bits != 0) revert Error.Overflow();
    }
}
