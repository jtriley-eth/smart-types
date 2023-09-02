# Code Pointer

## Overview

The `CodePointer` is an abstraction over [`Primitive`](ch02-01-primitive.md) to expose code specific
functionality. We define `CodePointer` as a `uint256` alias, however it only occupies 16 bits.

We define operations to read and copy code, as the code data location is read-only in the EVM
execution environment.

```solidity
CodePointer coptr;

coptr.read();
coptr.readAt(Primitive.wrap(32));
coptr.copy(address(this).code.length.asPrimitive());
```

## Layout

### Stack

The `CodePointer` value on the stack occupies 16 bits. There is no additional metadata packed into
the value.

| empty    | CodePointer |
| -------- | ----------- |
| 240 bits | 16 bits     |

## API

### Free Functions

#### read

Returns a value from the local code at the pointer.

```solidity
function read(CodePointer self) pure returns (Primitive result);
```

#### readAt

Returns a value from the local code at the pointer plus an offset.

```solidity
function readAt(CodePointer self, Primitive offset) pure returns (Primitive result);
```

#### copy

Copes the local code from the pointer to free memory with the provided length and returns the
[`MemoryPointer`](ch02-04-memory-pointer.md).

This allocates new memory.

```solidity
function copy(CodePointer self, Primitive length) pure returns (MemoryPointer ptr);
```

#### asPrimitive

Converts a `CodePointer` to [`Primitive`](ch02-01-primitive.md), performing no checks or mutations.

```solidity
function asPrimitive(CodePointer self) pure returns (Primitive);
```

### LibCodePointer

#### asCodePointer

Converts a [`Primitive`](ch02-01-primitive.md) to `CodePointer`, performing no checks or mutations.

```solidity
function asCodePointer(Primitive self) pure returns (CodePointer);
```

## Assumptions

- [`read`](#read) is not called with an out-of-bounds `CodePointer`.
- [`readAt`](#readat) is not performed beyond the size of the local code.

Both of the above, if violated, will treat all data beyond the calldata size as zeroed data.
