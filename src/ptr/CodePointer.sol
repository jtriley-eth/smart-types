// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";
import {MemoryPointer} from "src/ptr/MemoryPointer.sol";

// bit metadata layout
//
// | empty | ptr |
// | ----- | --- |
// | 224   | 16  |
type CodePointer is uint256;

using {read, readAt, copy, asPrimitive} for CodePointer global;

library LibCodePointer {
    function asCodePointer(Primitive self) internal pure returns (CodePointer) {
        return CodePointer.wrap(Primitive.unwrap(self));
    }
}

function read(CodePointer self) pure returns (Primitive result) {
    assembly {
        codecopy(0x00, self, 0x20)
        result := mload(0x00)
    }
}

function readAt(CodePointer self, Primitive offset) pure returns (Primitive result) {
    assembly {
        codecopy(0x00, add(self, offset), 0x20)
        result := mload(0x00)
    }
}

function copy(CodePointer self, Primitive length) pure returns (MemoryPointer ptr) {
    assembly {
        ptr := mload(0x40)
        mstore(0x40, add(ptr, length))
        codecopy(ptr, self, length)
    }
}

function asPrimitive(CodePointer self) pure returns (Primitive) {
    return Primitive.wrap(CodePointer.unwrap(self));
}
