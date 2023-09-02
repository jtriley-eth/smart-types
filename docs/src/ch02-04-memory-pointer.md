# Memory Pointer

## Overview

The `MemoryPointer` is an abstraction over [`Primitive`](ch02-01-primitive.md) to expose memory
specific functionality. We define `MemoryPointer` as a `uint256` alias, however it only occupies 32
bits.

We define operations to read, write, and copy memory.

## Layout

### Stack

The `MemoryPointer` value on the stack occupies 32 bits. There is no additional metadata packed into
the value. For a sized memory pointer, see [`Box`](ch02-07-box.md).

| empty    | MemoryPointer |
| -------- | --------------- |
| 224 bits | 32 bits         |

## API

### Free Functions

#### write

Writes a value to memory at the pointer, returning the current memory pointer to enable function
chaining.

```solidity
function write(MemoryPointer self, Primitive value) pure returns (MemoryPointer);
```

#### writeAt

Writes a value to memory at the pointer plus an offset, returning the current memory pointer to
enable function chaining.

```solidity
function writeAt(MemoryPointer self, Primitive offset, Primitive value) pure returns (MemoryPointer);
```

#### read

Returns a value from memory at the pointer.

```solidity
function read(MemoryPointer self) pure returns (Primitive);
```

#### readAt

Returns a value from memory at the pointer plus an offset.

```solidity
function readAt(MemoryPointer self, Primitive offset) pure returns (Primitive);
```

#### hash

Returns the keccak256 digest of a slice of memory at the pointer, given the length.

```solidity
function hash(MemoryPointer self, Primitive length) pure returns (Primitive digest);
```

#### hashAt

Returns the keccak256 digest of a slice of memory at the pointer plus an offset, given the length.

```solidity
function hashAt(MemoryPointer self, Primitive offset, Primitive length) pure returns (Primitive digest);
```

#### clone

Clones a slice of memory given the length and returns the newly allocated pointer.

This allocates new memory.

> At the time of writing, the EVM does not expose an opcode to copy a slice of memory. We always use
> the identity precompile for simplicity, despite there being a threshold at which copying slot by
> slot is profitable. This is a temporary solution until the mcopy instruction is implemented in the
> EVM.

```solidity
function clone(MemoryPointer self, Primitive length) pure returns (MemoryPointer ptr);
```

#### clear

Zeros a slice of memory given the length and returns the pointer to enable function chaining.

```solidity
function clear(MemoryPointer self, Primitive length) pure returns (MemoryPointer);
```

#### asPrimitive

Converts `MemoryPointer` to [`Primitive`](ch02-01-primitive.md), performing no checks or mutations.

```solidity
function asPrimitive(MemoryPointer self) pure returns (Primitive);
```

### LibMemoryPointer

#### freeMemoryPointer

Returns the value from Solidity's free memory pointer memory slot.

```solidity
function freeMemoryPointer() pure returns (MemoryPointer);
```

#### malloc

Allocates new memory given the length, and returns the pointer to the newly allocated memory.

This allocates new memory.

```solidity
function malloc(Primitive length) pure returns (MemoryPointer);
```

#### calloc

Allocates new memory given the length, zeroes it, and returns the pointer to the newly allocated
memory.

This allocates new memory.

```solidity
function calloc(Primitive length) pure returns (MemoryPointer);
```

#### mstore

Stores a value in free memory, returning the pointer to where the value was stored.

This allocates new memory.

```solidity
function mstore(Primitive value) pure returns (MemoryPointer);
```

#### asMemoryPointer

Converts a [`Primitive`](ch02-01-primitive.md) to `MemoryPointer`, performing no checks or
mutations.

```solidity
function asMemoryPointer(Primitive self) pure returns (MemoryPointer);
```

## Assumptions

- `MemoryPointer` only points to valid, allocated memory
- The free memory pointer is not overwritten (memory index `64`)
- The zero slot of memory is not overwritten (memory index `96`)

## Undefined Behavior

- Overwriting the free memory pointer
- Overwriting the zero slot
- Referencing a memory pointer from the scratch space (memory indices `0` and `32`)
