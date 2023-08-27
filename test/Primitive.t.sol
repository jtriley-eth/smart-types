// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "lib/forge-std/src/Test.sol";
import "test/base/PrimitiveAssertions.sol";
import "test/mock/MockPrimitive.sol";

import {Primitive, PrimitiveConstants, PrimitiveAs, PrimitiveError} from "src/Prelude.sol";

contract PrimitiveTest is Test, PrimitiveAssertions {
    using PrimitiveAs for *;
    using PrimitiveAs for uint248;

    MockPrimitive mock;

    function setUp() public {
        mock = new MockPrimitive();
    }

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

    function testFuzzAddChecked(Primitive lhs, Primitive rhs) public {
        unchecked {
            if (lhs.gt(PrimitiveConstants.MAX.sub(rhs)).asBool()) {
                vm.expectRevert(PrimitiveError.Overflow.selector);
                mock.addChecked(lhs, rhs);
            } else {
                assertEq(lhs.addChecked(rhs), lhs.add(rhs));
            }
        }
    }

    function testFuzzSub(Primitive lhs, Primitive rhs) public {
        unchecked {
            assertEq(lhs.sub(rhs).asUint256(), lhs.asUint256() - rhs.asUint256());
        }
    }

    function testFuzzSubChecked(Primitive lhs, Primitive rhs) public {
        unchecked {
            if (lhs.lt(rhs).asBool()) {
                vm.expectRevert(PrimitiveError.Underflow.selector);
                mock.subChecked(lhs, rhs);
            } else {
                assertEq(lhs.subChecked(rhs), lhs.sub(rhs));
            }
        }
    }

    function testFuzzMul(Primitive lhs, Primitive rhs) public {
        unchecked {
            assertEq(lhs.mul(rhs).asUint256(), lhs.asUint256() * rhs.asUint256());
        }
    }

    function testFuzzMulChecked(Primitive lhs, Primitive rhs) public {
        unchecked {
            if ((rhs.nonZero() & (lhs * rhs / rhs).neq(lhs)).asBool()) {
                vm.expectRevert(PrimitiveError.Overflow.selector);
                mock.mulChecked(lhs, rhs);
            } else {
                assertEq(lhs.mulChecked(rhs), lhs.mul(rhs));
            }
        }
    }

    function testFuzzDiv(Primitive lhs, Primitive rhs) public {
        assertEq(
            lhs.div(rhs).asUint256(),
            rhs.isZero().asBool() ? 0 : lhs.asUint256() / rhs.asUint256()
        );
    }

    function testFuzzDivChecked(Primitive lhs, Primitive rhs) public {
        unchecked {
            if (rhs.isZero().asBool()) {
                vm.expectRevert(PrimitiveError.DivisionByZero.selector);
                mock.divChecked(lhs, rhs);
            } else {
                assertEq(lhs.divChecked(rhs), lhs.div(rhs));
            }
        }
    }

    function testFuzzSignedDiv(Primitive lhs, Primitive rhs) public {
        assertEq(
            lhs.signedDiv(rhs).asInt256(),
            rhs.isZero().asBool() ? int256(0) : lhs.asInt256() / rhs.asInt256()
        );
    }

    function testFuzzSignedDivChecked(Primitive lhs, Primitive rhs) public {
        unchecked {
            if (rhs.isZero().asBool()) {
                vm.expectRevert(PrimitiveError.DivisionByZero.selector);
                mock.signedDivChecked(lhs, rhs);
            } else {
                assertEq(lhs.signedDivChecked(rhs), lhs.signedDiv(rhs));
            }
        }
    }

    function testFuzzMod(Primitive lhs, Primitive rhs) public {
        assertEq(
            lhs.mod(rhs).asUint256(),
            rhs.isZero().asBool() ? 0 : lhs.asUint256() % rhs.asUint256()
        );
    }

    function testFuzzModChecked(Primitive lhs, Primitive rhs) public {
        unchecked {
            if (rhs.isZero().asBool()) {
                vm.expectRevert(PrimitiveError.DivisionByZero.selector);
                mock.modChecked(lhs, rhs);
            } else {
                assertEq(lhs.modChecked(rhs), lhs.mod(rhs));
            }
        }
    }

    function testFuzzSignedMod(Primitive lhs, Primitive rhs) public {
        assertEq(
            lhs.signedMod(rhs).asInt256(),
            rhs.isZero().asBool() ? int256(0) : lhs.asInt256() % rhs.asInt256()
        );
    }

    function testFuzzSignedModChecked(Primitive lhs, Primitive rhs) public {
        unchecked {
            if (rhs.isZero().asBool()) {
                vm.expectRevert(PrimitiveError.DivisionByZero.selector);
                mock.signedModChecked(lhs, rhs);
            } else {
                assertEq(lhs.signedModChecked(rhs), lhs.signedMod(rhs));
            }
        }
    }

    function testFuzzAddMod(Primitive lhs, Primitive rhs, Primitive modulus) public {
        unchecked {
            assertEq(
                lhs.addMod(rhs, modulus).asUint256(),
                modulus.isZero().asBool()
                    ? 0
                    : addmod(lhs.asUint256(), rhs.asUint256(), modulus.asUint256())
            );
        }
    }

    function testFuzzAddModChecked(Primitive lhs, Primitive rhs, Primitive modulus) public {
        unchecked {
            if (modulus.isZero().asBool()) {
                vm.expectRevert(PrimitiveError.DivisionByZero.selector);
                mock.addModChecked(lhs, rhs, modulus);
            } else {
                assertEq(lhs.addModChecked(rhs, modulus), lhs.addMod(rhs, modulus));
            }
        }
    }

    function testFuzzMulMod(Primitive lhs, Primitive rhs, Primitive modulus) public {
        unchecked {
            assertEq(
                lhs.mulMod(rhs, modulus).asUint256(),
                modulus.isZero().asBool()
                    ? 0
                    : mulmod(lhs.asUint256(), rhs.asUint256(), modulus.asUint256())
            );
        }
    }

    function testFuzzMulModChecked(Primitive lhs, Primitive rhs, Primitive modulus) public {
        unchecked {
            if (modulus.isZero().asBool()) {
                vm.expectRevert(PrimitiveError.DivisionByZero.selector);
                mock.mulModChecked(lhs, rhs, modulus);
            } else {
                assertEq(lhs.mulModChecked(rhs, modulus), lhs.mulMod(rhs, modulus));
            }
        }
    }

    function testFuzzExp(Primitive base, Primitive exponent) public {
        unchecked {
            assertEq(
                base.exp(exponent).asUint256(),
                base.asUint256() ** exponent.asUint256()
            );
        }
    }

    function testFuzzIsZero(Primitive value) public {
        assertEq(value.isZero().asBool(), value.asUint256() == 0);
    }

    function testFuzzNonZero(Primitive value) public {
        assertEq(value.nonZero().asBool(), value.asUint256() != 0);
    }

    function testFuzzExtendSign(Primitive value, Primitive bits) public {
        bits = bound(bits.asUint256(), 0, 255).asPrimitive();
        uint256 res;
        assembly {
            res := signextend(div(bits, 8), value)
        }
        assertEq(res.asPrimitive(), value.extendSign(bits));
    }

    function testFuzzAnd(Primitive lhs, Primitive rhs) public {
        assertEq(lhs.and(rhs).asUint256(), lhs.asUint256() & rhs.asUint256());
    }

    function testFuzzOr(Primitive lhs, Primitive rhs) public {
        assertEq(lhs.or(rhs).asUint256(), lhs.asUint256() | rhs.asUint256());
    }

    function testFuzzXor(Primitive lhs, Primitive rhs) public {
        assertEq(lhs.xor(rhs).asUint256(), lhs.asUint256() ^ rhs.asUint256());
    }

    function testFuzzNot(Primitive value) public {
        assertEq(value.not().asUint256(), ~value.asUint256());
    }

    function testFuzzShl(Primitive value, Primitive bits) public {
        bits = bound(bits.asUint256(), 0, 255).asPrimitive();
        assertEq(
            value.shl(bits).asUint256(),
            value.asUint256() << bits.asUint256()
        );
    }

    function testFuzzShr(Primitive value, Primitive bits) public {
        bits = bound(bits.asUint256(), 0, 255).asPrimitive();
        assertEq(
            value.shr(bits).asUint256(),
            value.asUint256() >> bits.asUint256()
        );
    }

    function testFuzzRotr(Primitive value, Primitive bits) public {
        bits = bound(bits.asUint256(), 0, 255).asPrimitive();
        assertEq(
            value.rotr(bits).asUint256(),
            ((value.asUint256() >> bits.asUint256()) | (value.asUint256() << (256 - bits.asUint256())))
        );
    }

    function testFuzzRotl(Primitive value, Primitive bits) public {
        bits = bound(bits.asUint256(), 0, 255).asPrimitive();
        assertEq(
            value.rotl(bits).asUint256(),
            ((value.asUint256() << bits.asUint256()) | (value.asUint256() >> (256 - bits.asUint256())))
        );
    }

    function testFuzzRetainBits(Primitive value, Primitive bits) public {
        bits = bound(bits.asUint256(), 0, 255).asPrimitive();
        assertEq(
            value.retainBits(bits).asUint256(),
            value.asUint256() & ((1 << bits.asUint256()) - 1)
        );
    }

    function testFuzzConstrainBits(Primitive value, Primitive bits) public {
        bits = bound(bits.asUint256(), 0, 255).asPrimitive();
        if (value.gt(PrimitiveConstants.ONE.shl(bits).sub(PrimitiveConstants.ONE)).asBool()) {
            vm.expectRevert(PrimitiveError.Overflow.selector);
            mock.constrainBits(value, bits);
        } else {
            assertEq(value.constrainBits(bits), value.retainBits(bits));
        }
    }

    function testFuzzGetByte(Primitive value, Primitive index) public {
        if (index.gt(Primitive.wrap(31)).asBool()) {
            assertEq(value.getByte(index), PrimitiveConstants.ZERO);
        }
        index = bound(index.asUint256(), 0, 31).asPrimitive();
        assertEq(
            value.getByte(index).asUint256(),
            (value.asUint256() >> (31 - index.asUint256()) * 8) & 0xff
        );
    }

    function testFuzzTruthy(Primitive value) public {
        assertEq(value.truthy().asBool(), value.asUint256() != 0);
    }

    function testFuzzFalsy(Primitive value) public {
        assertEq(value.falsy().asBool(), value.asUint256() == 0);
    }

    function testFuzzLogicalNot(Primitive value) public {
        if (value.truthy().asBool()) {
            assertFalse(value.logicalNot().asBool());
        } else {
            assertTrue(value.logicalNot().asBool());
        }
    }

    function testFuzzAsBool(bool value) public {
        assertEq(value.asPrimitive().asBool(), value);
    }

    function testFuzzAsAddress(address value) public {
        assertEq(value.asPrimitive().asAddress(), value);
    }

    function testFuzzAsAddressPayable(address payable value) public {
        assertEq(address(value).asPrimitive().asAddressPayable(), value);
    }

    function testFuzzAsUint256(uint256 value) public {
        assertEq(value.asPrimitive().asUint256(), value);
    }

    function testFuzzAsUint248(uint248 value) public {
        assertEq(value.asPrimitive().asUint248(), value);
    }

    function testFuzzAsUint240(uint240 value) public {
        assertEq(value.asPrimitive().asUint240(), value);
    }

    function testFuzzAsUint232(uint232 value) public {
        assertEq(value.asPrimitive().asUint232(), value);
    }

    function testFuzzAsUint224(uint224 value) public {
        assertEq(value.asPrimitive().asUint224(), value);
    }

    function testFuzzAsUint216(uint216 value) public {
        assertEq(value.asPrimitive().asUint216(), value);
    }

    function testFuzzAsUint208(uint208 value) public {
        assertEq(value.asPrimitive().asUint208(), value);
    }

    function testFuzzAsUint200(uint200 value) public {
        assertEq(value.asPrimitive().asUint200(), value);
    }

    function testFuzzAsUint192(uint192 value) public {
        assertEq(value.asPrimitive().asUint192(), value);
    }

    function testFuzzAsUint184(uint184 value) public {
        assertEq(value.asPrimitive().asUint184(), value);
    }

    function testFuzzAsUint176(uint176 value) public {
        assertEq(value.asPrimitive().asUint176(), value);
    }

    function testFuzzAsUint168(uint168 value) public {
        assertEq(value.asPrimitive().asUint168(), value);
    }

    function testFuzzAsUint160(uint160 value) public {
        assertEq(value.asPrimitive().asUint160(), value);
    }

    function testFuzzAsUint152(uint152 value) public {
        assertEq(value.asPrimitive().asUint152(), value);
    }

    function testFuzzAsUint144(uint144 value) public {
        assertEq(value.asPrimitive().asUint144(), value);
    }

    function testFuzzAsUint136(uint136 value) public {
        assertEq(value.asPrimitive().asUint136(), value);
    }

    function testFuzzAsUint128(uint128 value) public {
        assertEq(value.asPrimitive().asUint128(), value);
    }

    function testFuzzAsUint120(uint120 value) public {
        assertEq(value.asPrimitive().asUint120(), value);
    }

    function testFuzzAsUint112(uint112 value) public {
        assertEq(value.asPrimitive().asUint112(), value);
    }

    function testFuzzAsUint104(uint104 value) public {
        assertEq(value.asPrimitive().asUint104(), value);
    }

    function testFuzzAsUint96(uint96 value) public {
        assertEq(value.asPrimitive().asUint96(), value);
    }

    function testFuzzAsUint88(uint88 value) public {
        assertEq(value.asPrimitive().asUint88(), value);
    }

    function testFuzzAsUint80(uint80 value) public {
        assertEq(value.asPrimitive().asUint80(), value);
    }

    function testFuzzAsUint72(uint72 value) public {
        assertEq(value.asPrimitive().asUint72(), value);
    }

    function testFuzzAsUint64(uint64 value) public {
        assertEq(value.asPrimitive().asUint64(), value);
    }

    function testFuzzAsUint56(uint56 value) public {
        assertEq(value.asPrimitive().asUint56(), value);
    }

    function testFuzzAsUint48(uint48 value) public {
        assertEq(value.asPrimitive().asUint48(), value);
    }

    function testFuzzAsUint40(uint40 value) public {
        assertEq(value.asPrimitive().asUint40(), value);
    }

    function testFuzzAsUint32(uint32 value) public {
        assertEq(value.asPrimitive().asUint32(), value);
    }

    function testFuzzAsUint24(uint24 value) public {
        assertEq(value.asPrimitive().asUint24(), value);
    }

    function testFuzzAsUint16(uint16 value) public {
        assertEq(value.asPrimitive().asUint16(), value);
    }

    function testFuzzAsUint8(uint8 value) public {
        assertEq(value.asPrimitive().asUint8(), value);
    }

    function testFuzzAsInt256(int256 value) public {
        assertEq(value.asPrimitive().asInt256(), value);
    }

    function testFuzzAsInt248(int248 value) public {
        assertEq(value.asPrimitive().asInt248(), value);
    }

    function testFuzzAsInt240(int240 value) public {
        assertEq(value.asPrimitive().asInt240(), value);
    }

    function testFuzzAsInt232(int232 value) public {
        assertEq(value.asPrimitive().asInt232(), value);
    }

    function testFuzzAsInt224(int224 value) public {
        assertEq(value.asPrimitive().asInt224(), value);
    }

    function testFuzzAsInt216(int216 value) public {
        assertEq(value.asPrimitive().asInt216(), value);
    }

    function testFuzzAsInt208(int208 value) public {
        assertEq(value.asPrimitive().asInt208(), value);
    }

    function testFuzzAsInt200(int200 value) public {
        assertEq(value.asPrimitive().asInt200(), value);
    }

    function testFuzzAsInt192(int192 value) public {
        assertEq(value.asPrimitive().asInt192(), value);
    }

    function testFuzzAsInt184(int184 value) public {
        assertEq(value.asPrimitive().asInt184(), value);
    }

    function testFuzzAsInt176(int176 value) public {
        assertEq(value.asPrimitive().asInt176(), value);
    }

    function testFuzzAsInt168(int168 value) public {
        assertEq(value.asPrimitive().asInt168(), value);
    }

    function testFuzzAsInt160(int160 value) public {
        assertEq(value.asPrimitive().asInt160(), value);
    }

    function testFuzzAsInt152(int152 value) public {
        assertEq(value.asPrimitive().asInt152(), value);
    }

    function testFuzzAsInt144(int144 value) public {
        assertEq(value.asPrimitive().asInt144(), value);
    }

    function testFuzzAsInt136(int136 value) public {
        assertEq(value.asPrimitive().asInt136(), value);
    }

    function testFuzzAsInt128(int128 value) public {
        assertEq(value.asPrimitive().asInt128(), value);
    }

    function testFuzzAsInt120(int120 value) public {
        assertEq(value.asPrimitive().asInt120(), value);
    }

    function testFuzzAsInt112(int112 value) public {
        assertEq(value.asPrimitive().asInt112(), value);
    }

    function testFuzzAsInt104(int104 value) public {
        assertEq(value.asPrimitive().asInt104(), value);
    }

    function testFuzzAsInt96(int96 value) public {
        assertEq(value.asPrimitive().asInt96(), value);
    }

    function testFuzzAsInt88(int88 value) public {
        assertEq(value.asPrimitive().asInt88(), value);
    }

    function testFuzzAsInt80(int80 value) public {
        assertEq(value.asPrimitive().asInt80(), value);
    }

    function testFuzzAsInt72(int72 value) public {
        assertEq(value.asPrimitive().asInt72(), value);
    }

    function testFuzzAsInt64(int64 value) public {
        assertEq(value.asPrimitive().asInt64(), value);
    }

    function testFuzzAsInt56(int56 value) public {
        assertEq(value.asPrimitive().asInt56(), value);
    }

    function testFuzzAsInt48(int48 value) public {
        assertEq(value.asPrimitive().asInt48(), value);
    }

    function testFuzzAsInt40(int40 value) public {
        assertEq(value.asPrimitive().asInt40(), value);
    }

    function testFuzzAsInt32(int32 value) public {
        assertEq(value.asPrimitive().asInt32(), value);
    }

    function testFuzzAsInt24(int24 value) public {
        assertEq(value.asPrimitive().asInt24(), value);
    }

    function testFuzzAsInt16(int16 value) public {
        assertEq(value.asPrimitive().asInt16(), value);
    }

    function testFuzzAsInt8(int8 value) public {
        assertEq(value.asPrimitive().asInt8(), value);
    }

    function testFuzzAsBytes32(bytes32 value) public {
        assertEq(value.asPrimitive().asBytes32(), value);
    }

    function testFuzzAsBytes31(bytes31 value) public {
        assertEq(value.asPrimitive().asBytes31(), value);
    }

    function testFuzzAsBytes30(bytes30 value) public {
        assertEq(value.asPrimitive().asBytes30(), value);
    }

    function testFuzzAsBytes29(bytes29 value) public {
        assertEq(value.asPrimitive().asBytes29(), value);
    }

    function testFuzzAsBytes28(bytes28 value) public {
        assertEq(value.asPrimitive().asBytes28(), value);
    }

    function testFuzzAsBytes27(bytes27 value) public {
        assertEq(value.asPrimitive().asBytes27(), value);
    }

    function testFuzzAsBytes26(bytes26 value) public {
        assertEq(value.asPrimitive().asBytes26(), value);
    }

    function testFuzzAsBytes25(bytes25 value) public {
        assertEq(value.asPrimitive().asBytes25(), value);
    }

    function testFuzzAsBytes24(bytes24 value) public {
        assertEq(value.asPrimitive().asBytes24(), value);
    }

    function testFuzzAsBytes23(bytes23 value) public {
        assertEq(value.asPrimitive().asBytes23(), value);
    }

    function testFuzzAsBytes22(bytes22 value) public {
        assertEq(value.asPrimitive().asBytes22(), value);
    }

    function testFuzzAsBytes21(bytes21 value) public {
        assertEq(value.asPrimitive().asBytes21(), value);
    }

    function testFuzzAsBytes20(bytes20 value) public {
        assertEq(value.asPrimitive().asBytes20(), value);
    }

    function testFuzzAsBytes19(bytes19 value) public {
        assertEq(value.asPrimitive().asBytes19(), value);
    }

    function testFuzzAsBytes18(bytes18 value) public {
        assertEq(value.asPrimitive().asBytes18(), value);
    }

    function testFuzzAsBytes17(bytes17 value) public {
        assertEq(value.asPrimitive().asBytes17(), value);
    }

    function testFuzzAsBytes16(bytes16 value) public {
        assertEq(value.asPrimitive().asBytes16(), value);
    }

    function testFuzzAsBytes15(bytes15 value) public {
        assertEq(value.asPrimitive().asBytes15(), value);
    }

    function testFuzzAsBytes14(bytes14 value) public {
        assertEq(value.asPrimitive().asBytes14(), value);
    }

    function testFuzzAsBytes13(bytes13 value) public {
        assertEq(value.asPrimitive().asBytes13(), value);
    }

    function testFuzzAsBytes12(bytes12 value) public {
        assertEq(value.asPrimitive().asBytes12(), value);
    }

    function testFuzzAsBytes11(bytes11 value) public {
        assertEq(value.asPrimitive().asBytes11(), value);
    }

    function testFuzzAsBytes10(bytes10 value) public {
        assertEq(value.asPrimitive().asBytes10(), value);
    }

    function testFuzzAsBytes9(bytes9 value) public {
        assertEq(value.asPrimitive().asBytes9(), value);
    }

    function testFuzzAsBytes8(bytes8 value) public {
        assertEq(value.asPrimitive().asBytes8(), value);
    }

    function testFuzzAsBytes7(bytes7 value) public {
        assertEq(value.asPrimitive().asBytes7(), value);
    }

    function testFuzzAsBytes6(bytes6 value) public {
        assertEq(value.asPrimitive().asBytes6(), value);
    }

    function testFuzzAsBytes5(bytes5 value) public {
        assertEq(value.asPrimitive().asBytes5(), value);
    }

    function testFuzzAsBytes4(bytes4 value) public {
        assertEq(value.asPrimitive().asBytes4(), value);
    }

    function testFuzzAsBytes3(bytes3 value) public {
        assertEq(value.asPrimitive().asBytes3(), value);
    }

    function testFuzzAsBytes2(bytes2 value) public {
        assertEq(value.asPrimitive().asBytes2(), value);
    }

    function testFuzzAsBytes1(bytes1 value) public {
        assertEq(value.asPrimitive().asBytes1(), value);
    }
}
