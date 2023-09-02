# Box

## Overview

The `Box` is a `uint256` value containing a pointer to memory and a length of the memory
segment, packed into a single stack value. It may be allocated directly or its pointer and length
provided from methods defined in `LibBox`. Additionally, it can be converted to and from a
`Primitive` with no checks or mutations using the 'as' convention.

```solidity
Box a = LibBox.malloc(size);
Box b = LibBox.toBox(pointer, length);
Box c = LibBox.writePrimitive(value);
Box d = c.reallocate(Primitive.wrap(64));
Box e = d.asPrimitive().asBox();
```

Data pointed to by the `Box` may be read or written, optionally from an additional offset,
and it may be hashed.

```solidity
Primitive one = Primitive.wrap(1);
Primitive two = Primitive.wrap(2);
Box a = LibBox.malloc(Primitive.wrap(64));

a.write(one);
a.writeAt(Primitive.wrap(32), two);

a.read();
a.readAt(Primitive.wrap(32));

a.hash();
```

## Layout

### Stack

The `Box` value on the stack occupies 64 bits. There is a 32 bit pointer and length packed
into the value.

| empty    | pointer | length  |
| -------- | ------- | ------- |
| 192 bits | 32 bits | 32 bits |

### Memory

The `Box` points to a slice of memory, however the structure of the data is not defined in
the scope of the type. Types that build upon `Box`, however, may specify their own
structure.

| start       | stop                   |
| ----------- | ---------------------- |
| `pointer()` | `pointer() + length()` |

## API

### Free Functions

#### pointer

Returns the 32 bit pointer to the underlying memory slice.

```solidity
function pointer(Box self) pure returns (Primitive);
```

#### length

Returns the 32 bit length of the underlying memory slice.

```solidity
function length(Box self) pure returns (Primitive);
```

#### realloc

Allocates a new slice of memory, copies the underlying data, and returns a new `Box`.

This does not destroy the old slice of memory.

If the Identity precompile static call fails, [`BoxError.MemoryCopy`](#memorycopy) is
thrown.

> At the time of writing, the [`mcopy`](https://eips.ethereum.org/EIPS/eip-5656) instruction is not
> implemented in the Ethereum Virtual Machine. Therefore, we use the Identity precompile until it is
> implemented.

```solidity
function realloc(Box self, Primitive newLen) pure returns (Box);
```

#### write

Writes a 32 byte `Primitive` value to memory at the [`pointer`](#pointer).

Returns the same `Box` to enable function chaining.

```solidity
function write(Box self, Primitive value) pure returns (Box);
```

#### writeAt

Writes a 32 byte `Primitive` value to memory at the [`pointer`](#pointer) plus an additional offset.

Returns the same `Box` to enable function chaining.

```solidity
function writeAt(Box self, Primitive offset, Primitive value) pure returns (Box);
```

#### read

Reads a 32 byte `Primitive` from memory at the [`pointer`](#pointer).

```solidity
function read(Box self) pure returns (Primitive);
```

#### readAt

Reads a 32 byte `Primitive` from memory at the [`pointer`](#pointer) plus an additional offset.

```solidity
function readAt(Box self, Primitive offset) pure returns (Primitive);
```

#### hash

Hashes the data in the underlying memory pointed to by the `Box`.

```solidity
function hash(Box self) pure returns (Primitive);
```

#### asPrimitive

Converts a `Box` to `Primitive`, performing no checks or mutations.

```solidity
function asPrimitive(Box self) pure returns (Primitive);
```

### LibBox

#### asBox

Converts a `Primitive` to `Box`, performing no checks or mutations.

Intended to be used as a type-checker bypass, this is not the proper way to construct a new
`Box`.

```solidity
function asBox(Primitive self) pure returns (Box);
```

#### toBox

Returns a new `Box`, given a pointer and length.

This function assumes the underlying memory slice referenced by the pointer and length is already
allocated.

```solidity
function toBox(Primitive ptr, Primitive len) pure returns (Box);
```

#### toBox

Converts a `bytes memory` to `Box` where the [`pointer`](#pointer) points to the start of
the bytes.

```solidity
function toBox(bytes memory data) pure returns (Box);
```

#### writePrimitive

Allocates a new `Box` of [`length`](#length) 32 and immediately writes a `Primitive` value
to it.

```solidity
function writePrimitive(Primitive value) pure returns (Box);
```

#### malloc

Allocates a new `Box` in memory.

This is the recommended method to create a new `Box`.

```solidity
function malloc(Primitive size) pure returns (Box);
```

### BoxConstants

#### FULL_MASK

64 bit mask, retains all bits of `Box`.

```solidity
Primitive constant FULL_MASK = Primitive.wrap(0xffffffffffffffff);
```

#### PTR_MASK

32 bit mask, retains all bits of [`pointer`](#pointer).

```solidity
Primitive constant PTR_MASK = Primitive.wrap(0xffffffff);
```

#### LEN_MASK

32 bit mask, retains all bits of [`length`](#length).

```solidity
Primitive constant LEN_MASK = Primitive.wrap(0xffffffff);
```

#### PTR_OFFSET

Bit offset of [`pointer`](#pointer) in the stack value.

```solidity
Primitive constant PTR_OFFSET = Primitive.wrap(32);
```

### BoxError

#### MemoryCopy

Thrown when a call to the Identity precompile fails in [`realloc`](#realloc).

```solidity
error MemoryCopy()
```

## Assumptions

- A `Primitive` converted to `Box` is properly constrained before calling [`asBox`](#asbox).

## Undefined Behavior

- Calling [`readAt`](#readat) with an offset greater than the length.
- Calling [`writeAt`](#writeat) with an offset greater than the length.
