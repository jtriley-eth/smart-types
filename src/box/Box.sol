// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {As as PrimitiveAs} from "src/primitive/As.sol";
import {Error} from "src/box/Error.sol";
import {Constants} from "src/box/Constants.sol";

// box metadata layout
//
// | empty | ptr | len |
// | ----- | --- | --- |
// | 192   | 32  | 32  |
type Box is uint256;

using {
    pointer,
    length,
    realloc,
    write,
    writeAt,
    read,
    readAt,
    hash,
    asPrimitive
} for Box global;
using LibBox for Box global;
using LibBox for Primitive;
using PrimitiveAs for uint256;

library LibBox {
    function asBox(Primitive self) internal pure returns (Box) {
        return Box.wrap(self.asUint256());
    }

    function toBox(Primitive ptr, Primitive len) internal pure returns (Box) {
        return ptr.and(Constants.PTR_MASK)
            .shl(Constants.PTR_OFFSET)
            .or(len.and(Constants.LEN_MASK))
            .asBox();
    }

    function toBox(bytes memory data) internal pure returns (Box) {
        Primitive ptr;
        assembly {
            ptr := add(data, 0x20)
        }
        return ptr.toBox(data.length.asPrimitive());
    }

    function mstore(Primitive value) internal pure returns (Box) {
        return malloc(Primitive.wrap(32)).write(value);
    }

    function malloc(Primitive size) internal pure returns (Box) {
        size = size.and(Constants.LEN_MASK);

        Primitive freeMemoryPointer;
        assembly ("memory-safe") {
            freeMemoryPointer := mload(0x40)
            mstore(0x40, add(freeMemoryPointer, size))
        }
        return toBox(freeMemoryPointer, size);
    }
}

function pointer(Box self) pure returns (Primitive) {
    return self.asPrimitive()
        .shr(Constants.PTR_OFFSET)
        .and(Constants.PTR_MASK);
}

function length(Box self) pure returns (Primitive) {
    return self.asPrimitive().and(Constants.LEN_MASK);
}

function realloc(Box self, Primitive newLen) pure returns (Box) {
    return __pure(__realloc)(self, newLen);
}

function write(Box self, Primitive value) pure returns (Box) {
    Primitive ptr = self.pointer();
    assembly {
        mstore(ptr, value)
    }
    return self;
}

function writeAt(Box self, Primitive offset, Primitive value) pure returns (Box) {
    Primitive ptr = self.pointer().add(offset);
    assembly {
        mstore(ptr, value)
    }
    return self;
}

function read(Box self) pure returns (Primitive value) {
    Primitive ptr = self.pointer();
    assembly {
        value := mload(ptr)
    }
}

function readAt(Box self, Primitive offset) pure returns (Primitive value) {
    Primitive ptr = self.pointer().add(offset);
    assembly {
        value := mload(ptr)
    }
}

function hash(Box self) pure returns (Primitive digest) {
    Primitive ptr = self.pointer();
    Primitive len = self.length();
    assembly {
        digest := keccak256(ptr, len)
    }
}

function asPrimitive(Box self) pure returns (Primitive) {
    return Primitive.wrap(Box.unwrap(self));
}

function __realloc(Box self, Primitive newLen) view returns (Box) {
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
    return LibBox.toBox(newPtr, newLen);
}

function __pure(
    function (Box, Primitive) view returns (Box) impureFn
) pure returns (
    function (Box, Primitive) pure returns (Box) pureFn
) {
    assembly {
        pureFn := impureFn
    }
}
