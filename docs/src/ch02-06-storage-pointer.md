# Storage Pointer

## Overview

The `StoragePointer` is an abstraction over [`Primitive`](ch02-01-primitive.md) to expose storage
specific functionality. We define `StoragePointer` as a `uint256` alias.

We define operations to read and write persistent storage.

```solidity
StoragePointer sptr;

sptr.read();
sptr.write(Primitive.wrap(1));
sptr.clear();
```

## Layout

### Stack

The `StoragePointer` value on the stack occupies all 256 bits.

| StoragePointer |
| -------------- |
| 256 bits       |

## API

### Free Functions

#### write

Writes a value to storage at the pointer and returns the pointer to enable function chaining.

```solidity
function write(StoragePointer self, Primitive value) returns (StoragePointer);
```

#### read

Returns a value from persistent storage at the pointer.

```solidity
function read(StoragePointer self) view returns (Primitive result);
```

#### clear

Clears a storage slot at the pointer and returns the pointer to enable function chaining.

```solidity
function clear(StoragePointer self) returns (StoragePointer);
```

#### asPrimitive

Converts a `StoragePointer` to [`Primitive`](ch02-01-primitive.md), performing no checks or
mutations.

```solidity
function asPrimitive(StoragePointer self) pure returns (Primitive);
```

### LibStoragePointer

#### asStoragePointer

Converts a [`Primitive`](ch02-01-primitive.md) to `StoragePointer`, performing no checks or
mutations.

```solidity
function asStoragePointer(Primitive self) pure returns (StoragePointer)
```
