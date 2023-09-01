// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {MemoryPointer} from "src/ptr/MemoryPointer.sol";

// bit metadata layout
//
// | empty | ptr |
// | ----- | --- |
// | 224   | 32  |
type CalldataPointer is uint256;

using {
    read,
    readAt,
    copy,
    // hash,
    asPrimitive
} for CalldataPointer global;

library LibCalldataPointer {
    function asCalldataPointer(Primitive self) internal pure returns (CalldataPointer) {
        return CalldataPointer.wrap(Primitive.unwrap(self));
    }
}

function read(CalldataPointer self) pure returns (Primitive result) {
    assembly {
        result := calldataload(self)
    }
}

function readAt(CalldataPointer self, Primitive offset) pure returns (Primitive result) {
    assembly {
        result := calldataload(add(self, offset))
    }
}

function copy(CalldataPointer self, Primitive length) pure returns (MemoryPointer ptr) {
    assembly {
        ptr := mload(0x40)
        mstore(0x40, add(ptr, length))
        calldatacopy(ptr, self, length)
    }
}

function asPrimitive(CalldataPointer self) pure returns (Primitive) {
    return Primitive.wrap(CalldataPointer.unwrap(self));
}
