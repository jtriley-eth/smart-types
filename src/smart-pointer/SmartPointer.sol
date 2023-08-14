// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {As as PrimitiveAs} from "src/primitive/As.sol";
import {Error} from "src/smart-pointer/Error.sol";

// smart pointer metadata layout
//
// | ptr | len |
// | --- | --- |
// | 32  | 32  |
type SmartPointer is uint64;

using PrimitiveAs for SmartPointer global;
using LibSmartPointer for SmartPointer global;

library LibSmartPointer {
    function newSmartPointer(Primitive ptr, Primitive len) internal pure returns (SmartPointer) {
        return SmartPointer.wrap(ptr.shl(Primitive.wrap(32)).or(len).asUint64());
    }

    function pointer(SmartPointer self) internal pure returns (Primitive) {
        return self.asPrimitive()
            .shr(Primitive.wrap(32));
    }

    function length(SmartPointer self) internal pure returns (Primitive) {
        return self.asPrimitive().and(Primitive.wrap(0xffffffff));
    }

    function malloc(Primitive size) internal pure returns (SmartPointer) {
        Primitive freeMemoryPointer;
        assembly ("memory-safe") {
            freeMemoryPointer := mload(0x40)
            mstore(0x40, add(freeMemoryPointer, size))
        }
        return newSmartPointer(freeMemoryPointer, size);
    }

    function realloc(SmartPointer self, Primitive newLen) internal pure returns (SmartPointer) {
        return __pure(__realloc)(self, newLen);
    }

    function write(SmartPointer self, Primitive value) internal pure {
        Primitive ptr = self.pointer();
        assembly ("memory-safe") {
            mstore(ptr, value)
        }
    }

    function read(SmartPointer self) internal pure returns (Primitive value) {
        Primitive ptr = self.pointer();
        assembly ("memory-safe") {
            value := mload(ptr)
        }
    }

    function readFrom(SmartPointer self, Primitive offset) internal pure returns (Primitive value) {
        Primitive ptr = self.pointer().add(offset);
        assembly ("memory-safe") {
            value := mload(ptr)
        }
    }

    function __realloc(SmartPointer self, Primitive newLen) private view returns (SmartPointer) {
        Primitive ptr = self.pointer();
        Primitive len = self.length();
        Primitive newPtr;
        Primitive success;
        assembly ("memory-safe") {
            newPtr := mload(0x40)
            mstore(0x40, add(newPtr, newLen))
            success := staticcall(gas(), 0x04, ptr, len, newPtr, newLen)
        }
        if (success.falsy().asBool()) revert Error.MemoryCopy();
        return newSmartPointer(newPtr, newLen);
    }

    function __pure(
        function (SmartPointer, Primitive) view returns (SmartPointer) impureFn
    ) private pure returns (
        function (SmartPointer, Primitive) pure returns (SmartPointer) pureFn
    ) {
        assembly {
            pureFn := impureFn
        }
    }
}
