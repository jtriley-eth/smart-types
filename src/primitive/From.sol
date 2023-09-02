// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {Box} from "src/box/Box.sol";
import {Error} from "src/primitive/Error.sol";

library From {
    function asBool(Primitive self) internal pure returns (bool) {
        unchecked { return Primitive.unwrap(self) != 0; }
    }

    function asAddress(Primitive self) internal pure returns (address) {
        unchecked { return address(uint160(Primitive.unwrap(self))); }
    }

    function asAddressPayable(Primitive self) internal pure returns (address payable) {
        unchecked { return payable(address(uint160(Primitive.unwrap(self)))); }
    }

    function asUint256(Primitive self) internal pure returns (uint256) {
        unchecked { return Primitive.unwrap(self); }
    }

    function asUint248(Primitive self) internal pure returns (uint248) {
        unchecked { return uint248(Primitive.unwrap(self)); }
    }

    function asUint240(Primitive self) internal pure returns (uint240) {
        unchecked { return uint240(Primitive.unwrap(self)); }
    }

    function asUint232(Primitive self) internal pure returns (uint232) {
        unchecked { return uint232(Primitive.unwrap(self)); }
    }

    function asUint224(Primitive self) internal pure returns (uint224) {
        unchecked { return uint224(Primitive.unwrap(self)); }
    }

    function asUint216(Primitive self) internal pure returns (uint216) {
        unchecked { return uint216(Primitive.unwrap(self)); }
    }

    function asUint208(Primitive self) internal pure returns (uint208) {
        unchecked { return uint208(Primitive.unwrap(self)); }
    }

    function asUint200(Primitive self) internal pure returns (uint200) {
        unchecked { return uint200(Primitive.unwrap(self)); }
    }

    function asUint192(Primitive self) internal pure returns (uint192) {
        unchecked { return uint192(Primitive.unwrap(self)); }
    }

    function asUint184(Primitive self) internal pure returns (uint184) {
        unchecked { return uint184(Primitive.unwrap(self)); }
    }

    function asUint176(Primitive self) internal pure returns (uint176) {
        unchecked { return uint176(Primitive.unwrap(self)); }
    }

    function asUint168(Primitive self) internal pure returns (uint168) {
        unchecked { return uint168(Primitive.unwrap(self)); }
    }

    function asUint160(Primitive self) internal pure returns (uint160) {
        unchecked { return uint160(Primitive.unwrap(self)); }
    }

    function asUint152(Primitive self) internal pure returns (uint152) {
        unchecked { return uint152(Primitive.unwrap(self)); }
    }

    function asUint144(Primitive self) internal pure returns (uint144) {
        unchecked { return uint144(Primitive.unwrap(self)); }
    }

    function asUint136(Primitive self) internal pure returns (uint136) {
        unchecked { return uint136(Primitive.unwrap(self)); }
    }

    function asUint128(Primitive self) internal pure returns (uint128) {
        unchecked { return uint128(Primitive.unwrap(self)); }
    }

    function asUint120(Primitive self) internal pure returns (uint120) {
        unchecked { return uint120(Primitive.unwrap(self)); }
    }

    function asUint112(Primitive self) internal pure returns (uint112) {
        unchecked { return uint112(Primitive.unwrap(self)); }
    }

    function asUint104(Primitive self) internal pure returns (uint104) {
        unchecked { return uint104(Primitive.unwrap(self)); }
    }

    function asUint96(Primitive self) internal pure returns (uint96) {
        unchecked { return uint96(Primitive.unwrap(self)); }
    }

    function asUint88(Primitive self) internal pure returns (uint88) {
        unchecked { return uint88(Primitive.unwrap(self)); }
    }

    function asUint80(Primitive self) internal pure returns (uint80) {
        unchecked { return uint80(Primitive.unwrap(self)); }
    }

    function asUint72(Primitive self) internal pure returns (uint72) {
        unchecked { return uint72(Primitive.unwrap(self)); }
    }

    function asUint64(Primitive self) internal pure returns (uint64) {
        unchecked { return uint64(Primitive.unwrap(self)); }
    }

    function asUint56(Primitive self) internal pure returns (uint56) {
        unchecked { return uint56(Primitive.unwrap(self)); }
    }

    function asUint48(Primitive self) internal pure returns (uint48) {
        unchecked { return uint48(Primitive.unwrap(self)); }
    }

    function asUint40(Primitive self) internal pure returns (uint40) {
        unchecked { return uint40(Primitive.unwrap(self)); }
    }

    function asUint32(Primitive self) internal pure returns (uint32) {
        unchecked { return uint32(Primitive.unwrap(self)); }
    }

    function asUint24(Primitive self) internal pure returns (uint24) {
        unchecked { return uint24(Primitive.unwrap(self)); }
    }

    function asUint16(Primitive self) internal pure returns (uint16) {
        unchecked { return uint16(Primitive.unwrap(self)); }
    }

    function asUint8(Primitive self) internal pure returns (uint8) {
        unchecked { return uint8(Primitive.unwrap(self)); }
    }

    function asInt256(Primitive self) internal pure returns (int256) {
        unchecked { return int256(Primitive.unwrap(self)); }
    }

    function asInt248(Primitive self) internal pure returns (int248) {
        unchecked { return int248(int256(Primitive.unwrap(self))); }
    }

    function asInt240(Primitive self) internal pure returns (int240) {
        unchecked { return int240(int256(Primitive.unwrap(self))); }
    }

    function asInt232(Primitive self) internal pure returns (int232) {
        unchecked { return int232(int256(Primitive.unwrap(self))); }
    }

    function asInt224(Primitive self) internal pure returns (int224) {
        unchecked { return int224(int256(Primitive.unwrap(self))); }
    }

    function asInt216(Primitive self) internal pure returns (int216) {
        unchecked { return int216(int256(Primitive.unwrap(self))); }
    }

    function asInt208(Primitive self) internal pure returns (int208) {
        unchecked { return int208(int256(Primitive.unwrap(self))); }
    }

    function asInt200(Primitive self) internal pure returns (int200) {
        unchecked { return int200(int256(Primitive.unwrap(self))); }
    }

    function asInt192(Primitive self) internal pure returns (int192) {
        unchecked { return int192(int256(Primitive.unwrap(self))); }
    }

    function asInt184(Primitive self) internal pure returns (int184) {
        unchecked { return int184(int256(Primitive.unwrap(self))); }
    }

    function asInt176(Primitive self) internal pure returns (int176) {
        unchecked { return int176(int256(Primitive.unwrap(self))); }
    }

    function asInt168(Primitive self) internal pure returns (int168) {
        unchecked { return int168(int256(Primitive.unwrap(self))); }
    }

    function asInt160(Primitive self) internal pure returns (int160) {
        unchecked { return int160(int256(Primitive.unwrap(self))); }
    }

    function asInt152(Primitive self) internal pure returns (int152) {
        unchecked { return int152(int256(Primitive.unwrap(self))); }
    }

    function asInt144(Primitive self) internal pure returns (int144) {
        unchecked { return int144(int256(Primitive.unwrap(self))); }
    }

    function asInt136(Primitive self) internal pure returns (int136) {
        unchecked { return int136(int256(Primitive.unwrap(self))); }
    }

    function asInt128(Primitive self) internal pure returns (int128) {
        unchecked { return int128(int256(Primitive.unwrap(self))); }
    }

    function asInt120(Primitive self) internal pure returns (int120) {
        unchecked { return int120(int256(Primitive.unwrap(self))); }
    }

    function asInt112(Primitive self) internal pure returns (int112) {
        unchecked { return int112(int256(Primitive.unwrap(self))); }
    }

    function asInt104(Primitive self) internal pure returns (int104) {
        unchecked { return int104(int256(Primitive.unwrap(self))); }
    }

    function asInt96(Primitive self) internal pure returns (int96) {
        unchecked { return int96(int256(Primitive.unwrap(self))); }
    }

    function asInt88(Primitive self) internal pure returns (int88) {
        unchecked { return int88(int256(Primitive.unwrap(self))); }
    }

    function asInt80(Primitive self) internal pure returns (int80) {
        unchecked { return int80(int256(Primitive.unwrap(self))); }
    }

    function asInt72(Primitive self) internal pure returns (int72) {
        unchecked { return int72(int256(Primitive.unwrap(self))); }
    }

    function asInt64(Primitive self) internal pure returns (int64) {
        unchecked { return int64(int256(Primitive.unwrap(self))); }
    }

    function asInt56(Primitive self) internal pure returns (int56) {
        unchecked { return int56(int256(Primitive.unwrap(self))); }
    }

    function asInt48(Primitive self) internal pure returns (int48) {
        unchecked { return int48(int256(Primitive.unwrap(self))); }
    }

    function asInt40(Primitive self) internal pure returns (int40) {
        unchecked { return int40(int256(Primitive.unwrap(self))); }
    }

    function asInt32(Primitive self) internal pure returns (int32) {
        unchecked { return int32(int256(Primitive.unwrap(self))); }
    }

    function asInt24(Primitive self) internal pure returns (int24) {
        unchecked { return int24(int256(Primitive.unwrap(self))); }
    }

    function asInt16(Primitive self) internal pure returns (int16) {
        unchecked { return int16(int256(Primitive.unwrap(self))); }
    }

    function asInt8(Primitive self) internal pure returns (int8) {
        unchecked { return int8(int256(Primitive.unwrap(self))); }
    }

    function asBytes32(Primitive self) internal pure returns (bytes32) {
        unchecked { return bytes32(Primitive.unwrap(self)); }
    }

    function asBytes31(Primitive self) internal pure returns (bytes31) {
        unchecked { return bytes31(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes30(Primitive self) internal pure returns (bytes30) {
        unchecked { return bytes30(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes29(Primitive self) internal pure returns (bytes29) {
        unchecked { return bytes29(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes28(Primitive self) internal pure returns (bytes28) {
        unchecked { return bytes28(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes27(Primitive self) internal pure returns (bytes27) {
        unchecked { return bytes27(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes26(Primitive self) internal pure returns (bytes26) {
        unchecked { return bytes26(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes25(Primitive self) internal pure returns (bytes25) {
        unchecked { return bytes25(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes24(Primitive self) internal pure returns (bytes24) {
        unchecked { return bytes24(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes23(Primitive self) internal pure returns (bytes23) {
        unchecked { return bytes23(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes22(Primitive self) internal pure returns (bytes22) {
        unchecked { return bytes22(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes21(Primitive self) internal pure returns (bytes21) {
        unchecked { return bytes21(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes20(Primitive self) internal pure returns (bytes20) {
        unchecked { return bytes20(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes19(Primitive self) internal pure returns (bytes19) {
        unchecked { return bytes19(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes18(Primitive self) internal pure returns (bytes18) {
        unchecked { return bytes18(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes17(Primitive self) internal pure returns (bytes17) {
        unchecked { return bytes17(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes16(Primitive self) internal pure returns (bytes16) {
        unchecked { return bytes16(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes15(Primitive self) internal pure returns (bytes15) {
        unchecked { return bytes15(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes14(Primitive self) internal pure returns (bytes14) {
        unchecked { return bytes14(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes13(Primitive self) internal pure returns (bytes13) {
        unchecked { return bytes13(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes12(Primitive self) internal pure returns (bytes12) {
        unchecked { return bytes12(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes11(Primitive self) internal pure returns (bytes11) {
        unchecked { return bytes11(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes10(Primitive self) internal pure returns (bytes10) {
        unchecked { return bytes10(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes9(Primitive self) internal pure returns (bytes9) {
        unchecked { return bytes9(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes8(Primitive self) internal pure returns (bytes8) {
        unchecked { return bytes8(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes7(Primitive self) internal pure returns (bytes7) {
        unchecked { return bytes7(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes6(Primitive self) internal pure returns (bytes6) {
        unchecked { return bytes6(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes5(Primitive self) internal pure returns (bytes5) {
        unchecked { return bytes5(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes4(Primitive self) internal pure returns (bytes4) {
        unchecked { return bytes4(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes3(Primitive self) internal pure returns (bytes3) {
        unchecked { return bytes3(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes2(Primitive self) internal pure returns (bytes2) {
        unchecked { return bytes2(bytes32(Primitive.unwrap(self))); }
    }

    function asBytes1(Primitive self) internal pure returns (bytes1) {
        unchecked { return bytes1(bytes32(Primitive.unwrap(self))); }
    }
}
