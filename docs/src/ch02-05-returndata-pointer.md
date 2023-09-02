# Returndata Pointer

## Overview

The `ReturndataPointer` is an abstraction over [`Primitive`](ch02-01-primitive.md) to expose
returndata specific functionality. We define `ReturndataPointer` as `uint256` alias, however it only
occupies 32 bits.

We define operations to read and copy returndata, as the returndata data location is read-only in
the EVM execution environment.

```solidity
ReturndataPointer rptr;

rptr.read();
rptr.readAt(Primitive.wrap(32));
rptr.copy(Primitive.wrap(64));
```

## Layout

### Stack

The `ReturndataPointer` value on the stack occupies 32 bits. There is no additional metadata packed
into the value.

| empty    | CalldataPointer |
| -------- | --------------- |
| 224 bits | 32 bits         |

## API

### Free Functions

#### read

Returns a value from returndata at the pointer.

```solidity
function read(ReturndataPointer self) pure returns (Primitive result);
```

#### readAt

Returns a value from returndata at the pointer plus an offset.

```solidity
function readAt(ReturndataPointer self, Primitive offset) pure returns (Primitive result);
```

#### copy

Copies returndata from the pointer to the free memory pointer with the provided length and returns
the [`MemoryPointer`](ch02-04-memory-pointer.md).

```solidity
function copy(ReturndataPointer self, Primitive length) pure returns (MemoryPointer ptr);
```

#### asPrimitive

Converts a `ReturndataPointer` to [`Primitive`](ch02-01-primitive.md), performing no checks or
mutations.

```solidity
function asPrimitive(ReturndataPointer self) pure returns (Primitive);
```

### LibReturndataPointer

#### asReturndataPointer

Converts a [`Primitive`](ch02-01-primitive.md) to `ReturndataPointer`, performing no checks or
mutations.

```solidity
function asReturndataPointer(Primitive self) internal pure returns (ReturndataPointer)
```

## Assumptions

- [`read`](#read) is not called with an out-of-bounds `ReturndataPointer`.
- [`readAt`](#readat) is not performed beyond the size of returndata.

Both of the above, if violated, will revert the transaction, per the behavior of the EVM.
