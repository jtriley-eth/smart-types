// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";

// bit metadata layout
//
// | storage pointer |
// | --------------- |
// | 256             |
type StoragePointer is uint256;

using {
    write,
    read,
    clear,
    asPrimitive
} for StoragePointer global;

library LibStoragePointer {
    function asStoragePointer(Primitive self) internal pure returns (StoragePointer) {
        return StoragePointer.wrap(Primitive.unwrap(self));
    }
}

function write(StoragePointer self, Primitive value) returns (StoragePointer) {
    assembly {
        sstore(self, value)
    }
    return self;
}

function read(StoragePointer self) view returns (Primitive result) {
    assembly {
        result := sload(self)
    }
}

function clear(StoragePointer self) returns (StoragePointer) {
    assembly {
        sstore(self, 0x00)
    }
    return self;
}

function asPrimitive(StoragePointer self) pure returns (Primitive) {
    return Primitive.wrap(StoragePointer.unwrap(self));
}
