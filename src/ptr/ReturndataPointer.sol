// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {MemoryPointer} from "src/ptr/MemoryPointer.sol";

// bit metadata layout
//
// | empty | ptr |
// | ----- | --- |
// | 224   | 32  |
type ReturndataPointer is uint256;

using {
    read,
    readAt,
    copy,
    asPrimitive
} for ReturndataPointer global;

library LibReturndataPointer {
    function asReturndataPointer(Primitive self) internal pure returns (ReturndataPointer) {
        return ReturndataPointer.wrap(Primitive.unwrap(self));
    }
}

function read(ReturndataPointer self) pure returns (Primitive result) {
    assembly {
        returndatacopy(0x00, self, 32)
        result := mload(0x00)
    }
}

function readAt(ReturndataPointer self, Primitive offset) pure returns (Primitive result) {
    assembly {
        returndatacopy(0x00, add(self, offset), 32)
        result := mload(0x00)
    }
}

function copy(ReturndataPointer self, Primitive length) pure returns (MemoryPointer ptr) {
    assembly {
        ptr := mload(0x40)
        mstore(0x40, add(ptr, length))
        returndatacopy(ptr, self, length)
    }
}

function asPrimitive(ReturndataPointer self) pure returns (Primitive) {
    return Primitive.wrap(ReturndataPointer.unwrap(self));
}
