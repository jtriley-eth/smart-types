// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {As as PrimitiveAs} from "src/primitive/As.sol";
import {Error} from "src/smart-pointer/Error.sol";
import {Constants} from "src/smart-pointer/Constants.sol";

// smart pointer metadata layout
//
// | empty | ptr | len |
// | ----- | --- | --- |
// | 192   | 32  | 32  |
type SmartPointer is uint256;

using {
    pointer,
    length,
    realloc,
    write,
    read,
    readFrom,
    asPrimitive
} for SmartPointer global;
using LibSmartPointer for SmartPointer global;
using LibSmartPointer for Primitive;

library LibSmartPointer {
    function asSmartPointer(Primitive self) internal pure returns (SmartPointer) {
        return SmartPointer.wrap(self.asUint64());
    }

    function newSmartPointer(Primitive ptr, Primitive len) internal pure returns (SmartPointer) {
        return ptr.shl(Constants.PTR_OFFSET).or(len).asSmartPointer();
    }

    function malloc(Primitive size) internal pure returns (SmartPointer) {
        Primitive freeMemoryPointer;
        assembly ("memory-safe") {
            freeMemoryPointer := mload(0x40)
            mstore(0x40, add(freeMemoryPointer, size))
        }
        return newSmartPointer(freeMemoryPointer, size);
    }
}

function pointer(SmartPointer self) pure returns (Primitive) {
    return self.asPrimitive()
        .shr(Constants.PTR_OFFSET)
        .and(Constants.PTR_MASK);
}

function length(SmartPointer self) pure returns (Primitive) {
    return self.asPrimitive().and(Constants.LEN_MASK);
}

function realloc(SmartPointer self, Primitive newLen) pure returns (SmartPointer) {
    return __pure(__realloc)(self, newLen);
}

function write(SmartPointer self, Primitive value) pure returns (SmartPointer) {
    Primitive ptr = self.pointer();
    assembly {
        mstore(ptr, value)
    }
    return self;
}

function read(SmartPointer self) pure returns (Primitive value) {
    Primitive ptr = self.pointer();
    assembly {
        value := mload(ptr)
    }
}

function readFrom(SmartPointer self, Primitive offset) pure returns (Primitive value) {
    Primitive ptr = self.pointer().add(offset);
    assembly {
        value := mload(ptr)
    }
}

function asPrimitive(SmartPointer self) pure returns (Primitive) {
    return Primitive.wrap(SmartPointer.unwrap(self));
}

function __realloc(SmartPointer self, Primitive newLen) view returns (SmartPointer) {
    Primitive ptr = self.pointer();
    Primitive len = self.length();
    Primitive newPtr;
    Primitive success;
    assembly {
        newPtr := mload(0x40)
        mstore(0x40, add(newPtr, newLen))
        success := staticcall(gas(), 0x04, ptr, len, newPtr, newLen)
    }
    if (success.falsy().asBool()) revert Error.MemoryCopy();
    return LibSmartPointer.newSmartPointer(newPtr, newLen);
}

function __pure(
    function (SmartPointer, Primitive) view returns (SmartPointer) impureFn
) pure returns (
    function (SmartPointer, Primitive) pure returns (SmartPointer) pureFn
) {
    assembly {
        pureFn := impureFn
    }
}
