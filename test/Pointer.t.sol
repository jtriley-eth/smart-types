// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "lib/forge-std/src/Test.sol";
import "test/base/PrimitiveAssertions.sol";
import "test/mock/MockReturnooor.sol";

import {
    CalldataPointer,
    LibCalldataPointer,
    CodePointer,
    LibCodePointer,
    MemoryPointer,
    LibMemoryPointer,
    ReturndataPointer,
    LibReturndataPointer,
    StoragePointer,
    LibStoragePointer,
    PrimitiveAs
} from "src/Prelude.sol";

using LibCalldataPointer for Primitive;
using LibCodePointer for Primitive;
using LibMemoryPointer for Primitive;
using LibReturndataPointer for Primitive;
using LibStoragePointer for Primitive;

contract PointerTest is Test, PrimitiveAssertions {
    using PrimitiveAs for *;

    address mockReturnooor;

    function setUp() public {
        mockReturnooor = address(new MockReturnooor());
    }

    function testFuzzCalldataPointerRead(Primitive data) public {
        CalldataPointer ptr = LibCalldataPointer.asCalldataPointer(Primitive.wrap(0x04));

        assertEq(data, ptr.read());
    }

    function testFuzzCalldataPointerReadAt(bytes calldata data, Primitive offset) public {
        offset = bound(offset.asUint256(), 4, data.length + 4).asPrimitive();
        Primitive value;

        assembly { value := calldataload(offset) }

        assertEq(
            value,
            CalldataPointer.wrap(0).readAt(offset)
        );
    }

    function testFuzzCalldataPointerCopy(bytes calldata data, Primitive start, Primitive length) public {
        start = bound(start.asUint256(), 4, data.length + 4).asPrimitive();
        length = bound(length.asUint256(), 0, data.length + 4 - start.asUint256()).asPrimitive();
        MemoryPointer mPtr = start.asCalldataPointer().copy(length);
        Primitive digest;

        assembly {
            let cdPtr := mload(0x40)
            mstore(0x40, add(cdPtr, length))
            calldatacopy(cdPtr, start, length)
            digest := keccak256(cdPtr, length)
        }

        assertEq(mPtr.hash(length), digest);
    }

    function testFuzzCalldataPointerAsPrimitive(Primitive data) public {
        assertEq(data, data.asCalldataPointer().asPrimitive());
    }

    function testFuzzCodePointerRead(Primitive ptr) public {
        ptr = bound(ptr.asUint256(), 0, address(this).code.length - 32).asPrimitive();
        Primitive expected;

        assembly {
            codecopy(0x00, ptr, 0x20)
            expected := mload(0x00)
        }

        assertEq(ptr.asCodePointer().read(), expected);
    }

    function testFuzzCodePointerCopy(Primitive ptr, Primitive length) public {
        ptr = bound(ptr.asUint256(), 0, address(this).code.length - 32).asPrimitive();
        length = bound(length.asUint256(), 0, address(this).code.length - ptr.asUint256()).asPrimitive();
        MemoryPointer mPtr = ptr.asCodePointer().copy(length);
        Primitive digest;

        assembly {
            let cdPtr := mload(0x40)
            mstore(0x40, add(cdPtr, length))
            codecopy(cdPtr, ptr, length)
            digest := keccak256(cdPtr, length)
        }

        assertEq(mPtr.hash(length), digest);
    }

    function testFuzzCodePointerAsPrimitive(Primitive ptr) public {
        assertEq(ptr, ptr.asCodePointer().asPrimitive());
    }

    function testFuzzFreeMemoryPointer(bytes memory) public {
        Primitive freeMemoryPointer;

        assembly {
            freeMemoryPointer := mload(0x40)
        }

        assertEq(
            freeMemoryPointer,
            LibMemoryPointer.freeMemoryPointer().asPrimitive()
        );
    }

    function testFuzzMemoryPointerMalloc(Primitive size) public {
        size = bound(size.asUint256(), 0, type(uint16).max).asPrimitive();
        MemoryPointer ptr = LibMemoryPointer.malloc(size);
        Primitive freeMemoryPointer;

        assembly {
            freeMemoryPointer := mload(0x40)
        }

        assertEq(
            ptr.asPrimitive() + size,
            freeMemoryPointer
        );
    }

    function testFuzzMemoryPointerCalloc(Primitive size) public {
        size = bound(size.asUint256(), 32, type(uint16).max).asPrimitive();

        assembly { mstore(mload(0x40), 0x01)}

        MemoryPointer ptr = LibMemoryPointer.calloc(size);
        Primitive freeMemoryPointer;

        assembly {
            freeMemoryPointer := mload(0x40)
        }

        assertEq(
            ptr.asPrimitive() + size,
            freeMemoryPointer
        );
        assertEq(ptr.read(), Primitive.wrap(0));
    }

    function testFuzzMemoryPointerMstore(Primitive value) public {
        MemoryPointer ptr = value.mstore();
        Primitive rawValue;

        assembly {
            rawValue := mload(ptr)
        }
        assertEq(rawValue, value);
    }

    function testFuzzMemoryPointerAsPrimitive(Primitive ptr) public {
        assertEq(ptr, ptr.asCalldataPointer().asPrimitive());
    }

    function testFuzzMemoryPointerWrite(Primitive value) public {
        MemoryPointer mPtr = LibMemoryPointer.malloc(Primitive.wrap(32)).write(value);

        assertEq(mPtr.read(), value);
    }

    function testFuzzMemoryPointerWriteAt(Primitive size, Primitive offset, Primitive value) public {
        size = bound(size.asUint256(), 32, type(uint16).max).asPrimitive();
        offset = bound(offset.asUint256(), 0, size.asUint256() - 32).asPrimitive();
        MemoryPointer mPtr = LibMemoryPointer.malloc(size).writeAt(offset, value);

        Primitive rawValue;
        assembly { rawValue := mload(add(mPtr, offset)) }

        assertEq(rawValue, value);
    }

    function testFuzzMemoryPointerRead(Primitive value) public {
        MemoryPointer mPtr = value.mstore();

        assertEq(mPtr.read(), value);
    }

    function testFuzzMemoryPointerReadAt(Primitive size, Primitive offset, Primitive value) public {
        size = bound(size.asUint256(), 32, type(uint16).max).asPrimitive();
        offset = bound(offset.asUint256(), 0, size.asUint256() - 32).asPrimitive();
        MemoryPointer mPtr = LibMemoryPointer.malloc(size);

        assembly { mstore(add(mPtr, offset), value) }

        assertEq(mPtr.readAt(offset), value);
    }

    function testFuzzMemoryPointerHash(bytes memory data) public {
        MemoryPointer mPtr;
        assembly { mPtr := add(data, 0x20) }
        assertEq(
            mPtr.hash(data.length.asPrimitive()),
            keccak256(abi.encodePacked(data)).asPrimitive()
        );
    }

    function testFuzzMemoryPointerHashAt(bytes memory data) public {
        MemoryPointer mPtr;
        assembly { mPtr := data }
        assertEq(
            mPtr.hashAt(Primitive.wrap(32), data.length.asPrimitive()),
            keccak256(abi.encodePacked(data)).asPrimitive()
        );
    }

    function testFuzzMemoryPointerClone(bytes memory data) public {
        Primitive size = data.length.asPrimitive();
        MemoryPointer mPtr;
        assembly { mPtr := data }
        MemoryPointer clone = mPtr.clone(size);

        assertEq(clone.hash(size), mPtr.hash(size));
    }

    function testfuzzMemoryPointerClear(bytes memory data) public {
        Primitive size = data.length.asPrimitive();
        MemoryPointer mPtr;
        MemoryPointer clearedPtr;
        assembly {
            mPtr := data

            clearedPtr := mload(0x40)
            mstore(0x40, add(clearedPtr, size))
            calldatacopy(clearedPtr, calldatasize(), size)
        }
        assertEq(
            mPtr.clone(size).clear(size).hash(size),
            clearedPtr.hash(size)
        );
    }

    function testFuzzReturndataPointerAsPrimitive(Primitive ptr) public {
        assertEq(ptr, ptr.asReturndataPointer().asPrimitive());
    }

    function testFuzzReturndataPointerRead(Primitive value) public {
        Primitive success;
        MemoryPointer mPtr = value.mstore();
        assembly {
            success := staticcall(gas(), sload(mockReturnooor.slot), mPtr, 0x20, 0x00, 0x00)
        }
        assertTrue(success);
        assertEq(value, ReturndataPointer.wrap(0).read());
    }

    function testFuzzReturndataPointerReadAt(bytes memory data, Primitive offset) public {
        vm.assume(data.length > 32);
        offset = bound(offset.asUint256(), 0, data.length - 32).asPrimitive();

        (bool success, ) = mockReturnooor.call(data);
        assertTrue(success);

        Primitive rawValue;
        assembly {
            returndatacopy(0x00, offset, 0x20)
            rawValue := mload(0x00)
        }
        assertEq(
            rawValue,
            ReturndataPointer.wrap(0).readAt(offset)
        );
    }

    function testFuzzReturndataPointerCopy(bytes memory data, Primitive ptr, Primitive len) public {
        ptr = bound(ptr.asUint256(), 0, data.length).asPrimitive();
        len = bound(len.asUint256(), 0, data.length - ptr.asUint256()).asPrimitive();

        (bool success, ) = mockReturnooor.call(data);
        assertTrue(success);

        Primitive digest;
        assembly {
            let ret := mload(0x40)
            mstore(0x40, add(ret, len))
            returndatacopy(ret, ptr, len)
            digest := keccak256(ret, len)
        }

        assertEq(ptr.asReturndataPointer().copy(len).hash(len), digest);
    }

    function testFuzzStoragePointerAsPrimitive(Primitive ptr) public {
        assertEq(ptr, ptr.asStoragePointer().asPrimitive());
    }

    function testFuzzStoragePointerWrite(StoragePointer key, Primitive value) public {
        vm.assume(key.asPrimitive().asUint256() != 0);
        key.write(value);

        assertEq(vm.load(address(this), key.asPrimitive().asBytes32()).asPrimitive(), value);
    }

    function testFuzzStoragePointerRead(StoragePointer key, Primitive value) public {
        vm.assume(key.asPrimitive().asUint256() != 0);
        vm.store(address(this), key.asPrimitive().asBytes32(), value.asBytes32());

        assertEq(key.read(), value);
    }

    function testFuzzStoragePointerClear(StoragePointer key, Primitive value) public {
        vm.assume(key.asPrimitive().asUint256() != 0);
        vm.store(address(this), key.asPrimitive().asBytes32(), value.asBytes32());

        assertEq(key.clear().read(), Primitive.wrap(0));
    }
}
