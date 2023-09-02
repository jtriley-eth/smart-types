// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "lib/forge-std/src/Test.sol";
import "test/base/PrimitiveAssertions.sol";

import {Primitive, PrimitiveAs, Box, BoxConstants, BoxError, LibBox} from "src/Prelude.sol";

using LibBox for Primitive;

contract BoxTest is Test, PrimitiveAssertions {
    using PrimitiveAs for *;
    using LibBox for bytes;

    function testFuzzAsBox(Primitive value) public {
        assertEq(value.asBox().asPrimitive(), value);
    }

    function testFuzzToBox(Primitive ptr, Primitive len) public {
        assertEq(
            ptr.toBox(len).asPrimitive(),
            (((ptr.asUint256() & type(uint32).max) << 32) | (len.asUint256() & type(uint32).max)).asPrimitive()
        );
    }

    function testFuzzToBoxFromBytes(bytes memory data) public {
        Box box = data.toBox();
        Primitive ptr;
        assembly { ptr := add(data, 0x20) }
        assertEq(box.pointer(), ptr);
        assertEq(box.length(), data.length.asPrimitive());
    }

    function testFuzzWritePrimitive(Primitive value) public {
        assertEq(value.writePrimitive().read(), value);
    }

    function testFuzzMalloc(uint32 size) public {
        Box box = size.asPrimitive().malloc();
        Primitive freeMemPtr;
        assembly {
            freeMemPtr := mload(0x40)
        }
        assertEq(freeMemPtr.sub(size.asPrimitive()), box.pointer());
        assertEq(box.length(), size.asPrimitive());
    }

    function testPointer(uint32 size) public {
        Box box = size.asPrimitive().malloc();
        assertEq(
            box.pointer(),
            box.asPrimitive()
                .shr(BoxConstants.PTR_OFFSET)
                .and(BoxConstants.PTR_MASK)
        );
    }

    function testLength(uint32 size) public {
        Box box = size.asPrimitive().malloc();
        assertEq(
            box.length(),
            box.asPrimitive().and(BoxConstants.LEN_MASK)
        );
    }

    function testFuzzRealloc(uint16 size, uint16 newSize) public {
        (size, newSize) = size < newSize ? (size, newSize) : (newSize, size);
        Box box = size.asPrimitive().malloc();

        assertEq(box.length(), size.asPrimitive());
        Box reallocatedBox = box.realloc(newSize.asPrimitive());
        assertEq(reallocatedBox.length(), newSize.asPrimitive());
        assertLe(box.pointer(), reallocatedBox.pointer());
    }

    function testFuzzWrite(Primitive value) public {
        Box box = Primitive.wrap(32).malloc();
        Primitive ptr = box.pointer();
        Primitive rawValue;

        box.write(value);
        assembly { rawValue := mload(ptr) }

        assertEq(rawValue, value);
    }

    function testFuzzWriteAt(Primitive value, Primitive slots, Primitive slot) public {
        slots = bound(slots.asUint256(), 1, 255).asPrimitive();
        slot = bound(slot.asUint256(), 0, slots.asUint256() - 1).asPrimitive().mul(Primitive.wrap(32));
        Box box = slots.mul(Primitive.wrap(32)).malloc();
        Primitive ptr = box.pointer();
        Primitive rawValue;
 
        box.writeAt(slot, value);
        assembly { rawValue := mload(add(ptr, slot)) }

        assertEq(rawValue, value);
    }

    function testFuzzRead(Primitive value) public {
        Box box = LibBox.writePrimitive(value);

        assertEq(box.read(), value);
    }

    function testFuzzReadAt(Primitive value, Primitive slots, Primitive slot) public {
        slots = bound(slots.asUint256(), 1, 255).asPrimitive();
        slot = bound(slot.asUint256(), 0, slots.asUint256() - 1).asPrimitive().mul(Primitive.wrap(32));
        Box box = slots.mul(Primitive.wrap(32)).malloc().writeAt(slot, value);

        assertEq(box.readAt(slot), value);
    }

    function testFuzzHash(bytes memory data) public {
        assertEq(
            keccak256(data).asPrimitive(),
            data.toBox().hash()
        );
    }
}
