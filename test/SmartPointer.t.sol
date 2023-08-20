// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/forge-std/src/Test.sol";
import "test/base/PrimitiveAssertions.sol";

import {Primitive, PrimitiveAs, SmartPointer, SmartPointerConstants, SmartPointerError, LibSmartPointer} from "src/Prelude.sol";

using LibSmartPointer for Primitive;

contract SmartPointerTest is Test, PrimitiveAssertions {
    using PrimitiveAs for *;

    function testFuzzAsSmartPointer(Primitive value) public {
        assertEq(value.asSmartPointer().asPrimitive(), value);
    }

    function testFuzzToSmartPointer(Primitive ptr, Primitive len) public {
        assertEq(
            ptr.toSmartPointer(len).asPrimitive(),
            (((ptr.asUint256() & type(uint32).max) << 32) | (len.asUint256() & type(uint32).max)).asPrimitive()
        );
    }

    function testFuzzMalloc(uint32 size) public {
        SmartPointer smartPointer = size.asPrimitive().malloc();
        Primitive freeMemPtr;
        assembly {
            freeMemPtr := mload(0x40)
        }
        assertEq(freeMemPtr.sub(size.asPrimitive()), smartPointer.pointer());
        assertEq(smartPointer.length(), size.asPrimitive());
    }

    function testPointer(uint32 size) public {
        SmartPointer smartPointer = size.asPrimitive().malloc();
        assertEq(
            smartPointer.pointer(),
            smartPointer.asPrimitive()
                .shr(SmartPointerConstants.PTR_OFFSET)
                .and(SmartPointerConstants.PTR_MASK)
        );
    }

    function testLength(uint32 size) public {
        SmartPointer smartPointer = size.asPrimitive().malloc();
        assertEq(
            smartPointer.length(),
            smartPointer.asPrimitive().and(SmartPointerConstants.LEN_MASK)
        );
    }

    function testFuzzRealloc(uint16 size, uint16 newSize) public {
        (size, newSize) = size < newSize ? (size, newSize) : (newSize, size);
        SmartPointer smartPointer = size.asPrimitive().malloc();

        assertEq(smartPointer.length(), size.asPrimitive());
        SmartPointer reallocatedSmartPointer = smartPointer.realloc(newSize.asPrimitive());
        assertEq(reallocatedSmartPointer.length(), newSize.asPrimitive());
        assertLe(smartPointer.pointer(), reallocatedSmartPointer.pointer());
    }

    function testFuzzWrite(Primitive value) public {
        SmartPointer smartPointer = Primitive.wrap(32).malloc();
        Primitive ptr = smartPointer.pointer();
        Primitive rawValue;

        smartPointer.write(value);
        assembly { rawValue := mload(ptr) }

        assertEq(rawValue, value);
    }

    function testFuzzWriteAt(Primitive value, Primitive slots, Primitive slot) public {
        slots = bound(slots.asUint256(), 1, 255).asPrimitive();
        slot = bound(slot.asUint256(), 0, slots.asUint256() - 1).asPrimitive().mul(Primitive.wrap(32));
        SmartPointer smartPointer = slots.mul(Primitive.wrap(32)).malloc();
        Primitive ptr = smartPointer.pointer();
        Primitive rawValue;
 
        smartPointer.writeAt(slot, value);
        assembly { rawValue := mload(add(ptr, slot)) }

        assertEq(rawValue, value);
    }

    function testFuzzRead(Primitive value) public {
        SmartPointer smartPointer = Primitive.wrap(32).malloc().write(value);

        assertEq(smartPointer.read(), value);
    }

    function testFuzzReadAt(Primitive value, Primitive slots, Primitive slot) public {
        slots = bound(slots.asUint256(), 1, 255).asPrimitive();
        slot = bound(slot.asUint256(), 0, slots.asUint256() - 1).asPrimitive().mul(Primitive.wrap(32));
        SmartPointer smartPointer = slots.mul(Primitive.wrap(32)).malloc().writeAt(slot, value);

        assertEq(smartPointer.readAt(slot), value);
    }
}
