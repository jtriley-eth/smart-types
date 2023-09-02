// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";

// bit metadata layout
//
// | empty | ptr |
// | ----- | --- |
// | 224   | 32  |
type MemoryPointer is uint256;

using {
    write,
    writeAt,
    read,
    readAt,
    hash,
    hashAt,
    clone,
    clear,
    asPrimitive
} for MemoryPointer global;
using LibMemoryPointer for Primitive;

library LibMemoryPointer {
    function freeMemoryPointer() internal pure returns (MemoryPointer ptr) {
        assembly { ptr := mload(0x40) }
    }

    function malloc(Primitive length) internal pure returns (MemoryPointer ptr) {
        assembly ("memory-safe") {
            ptr := mload(0x40)
            mstore(0x40, add(ptr, length))
        }
    }

    function calloc(Primitive length) internal pure returns (MemoryPointer) {
        return malloc(length).clear(length);
    }

    function mstore(Primitive value) internal pure returns (MemoryPointer ptr) {
        return malloc(Primitive.wrap(32)).write(value);
    }

    function asMemoryPointer(Primitive self) internal pure returns (MemoryPointer) {
        return MemoryPointer.wrap(Primitive.unwrap(self));
    }
}

function write(MemoryPointer self, Primitive value) pure returns (MemoryPointer) {
    assembly {
        mstore(self, value)
    }
    return self;
}

function writeAt(MemoryPointer self, Primitive offset, Primitive value) pure returns (MemoryPointer) {
    assembly {
        mstore(add(self, offset), value)
    }
    return self;
}

function read(MemoryPointer self) pure returns (Primitive) {
    Primitive value;
    assembly {
        value := mload(self)
    }
    return value;
}

function readAt(MemoryPointer self, Primitive offset) pure returns (Primitive) {
    Primitive value;
    assembly {
        value := mload(add(self, offset))
    }
    return value;
}

function hash(MemoryPointer self, Primitive length) pure returns (Primitive digest) {
    assembly {
        digest := keccak256(self, length)
    }
}

function hashAt(MemoryPointer self, Primitive offset, Primitive length) pure returns (Primitive digest) {
    assembly {
        digest := keccak256(add(self, offset), length)
    }
}

function clone(MemoryPointer self, Primitive length) pure returns (MemoryPointer ptr) {
    return __purify(__clone)(self, length);
}

function clear(MemoryPointer self, Primitive length) pure returns (MemoryPointer) {
    assembly {
        calldatacopy(self, calldatasize(), length)
    }
    return self;
}

function asPrimitive(MemoryPointer self) pure returns (Primitive) {
    return Primitive.wrap(MemoryPointer.unwrap(self));
}

function __clone(MemoryPointer self, Primitive length) view returns (MemoryPointer ptr) {
    assembly {
        ptr := mload(0x40)
        mstore(0x40, add(ptr, length))
        if iszero(staticcall(gas(), 0x04, self, length, ptr, length)) {
            revert(0x00, 0x00)
        }
    }
}

function __purify(
    function (MemoryPointer, Primitive) view returns (MemoryPointer) impureFn
) pure returns (
    function (MemoryPointer, Primitive) pure returns (MemoryPointer) pureFn
) {
    assembly {
        pureFn := impureFn
    }
}
