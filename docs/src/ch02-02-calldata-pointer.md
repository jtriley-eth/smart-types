# Calldata Pointer

## Overview

The `CalldataPointer` is an abstraction over [`Primitive`](ch02-01-primitive.md) to expose calldata
specific functionality. We define `CalldataPointer` as a `uint256` alias, however it only occupies
32 bits.

We define operations to read and copy calldata, as the calldata data location is read-only in the
EVM execution environment.

```solidity
CalldataPointer cdptr;

cdptr.read();
cdptr.readAt(Primitive.wrap(32));
cdptr.copy(msg.data.length.asPrimitive());
```

## Layout

### Stack

The `CalldataPointer` value on the stack occupies 32 bits. There is no additional metadata packed
into the value.

| empty    | CalldataPointer |
| -------- | --------------- |
| 224 bits | 32 bits         |

## API

### Free Functions

#### read

Returns a value from calldata at the pointer.

```solidity
function read(CalldataPointer self) pure returns (Primitive result);
```

#### readAt

Returns a value from calldata at the pointer plus an offset.

```solidity
function readAt(CalldataPointer self, Primitive offset) pure returns (Primitive result);
```

#### copy

Copies calldata from the pointer to free memory with the provided length and returns the
[`MemoryPointer`](ch02-04-memory-pointer.md).

This allocates new memory.

```solidity
function copy(CalldataPointer self, Primitive length) pure returns (MemoryPointer ptr);
```

#### asPrimitive

Converts a `CalldataPointer` to [`Primitive`](ch02-01-primitive.md), performing no checks or
mutations.

```solidity
function asPrimitive(CalldataPointer self) pure returns (Primitive);
```

### LibCalldataPointer

#### asCalldataPointer

Converts a [`Primitive`](ch02-01-primitive.md) to `CalldataPointer`, performing no checks or
mutations.

```solidity
function asCalldataPointer(Primitive self) pure returns (CalldataPointer);
```

## Assumptions

- [`read`](#read) is not called with an out-of-bounds `CalldataPointer`.
- [`readAt`](#readat) is not performed beyond the size of calldata.

Both of the above, if violated, will treat all data beyond the calldata size as zeroed data.
