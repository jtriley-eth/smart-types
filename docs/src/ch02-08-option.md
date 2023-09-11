# Option

## Overview

The `Option` type is a sum type, with members `None` with no data or `Some` with a
[`MemoryPointer`](ch02-04-memory-pointer.md) to the underlying data. It may be created using
`LibOption` with the appropriate function.

```solidity
Option maybeSomething = LibOption.Some(memPtr);
Option definitelyNothing = LibOption.None();
```

The underlying [`MemoryPointer`](ch02-04-memory-pointer.md) should only be accessed by a method that
handles the members first. We can revert on `None` with or without a custom message, and we can
provide either a default value or a function that constructs a default value.

```solidity
Option a;

a.expect("error: no data");
a.unwrapOrElse(allocate);
```

## Layout

### Stack

The `Option` value on the stack occupies 72 bits. There is a 64 bit
[`MemoryPointer`](ch02-04-memory-pointer.md) packed with an eight bit `Member` enumeration.

The `Member` enumeration is not exported externally, as it should never be accessed directly. It
represents either `None` or `Some`, where `Some` is accompanied by a
[`MemoryPointer`](ch02-04-memory-pointer.md) while `None` is not.

| empty    | Member | MemoryPointer |
| -------- | ------ | ------------- |
| 184 bits | 8 bits | 64 bits       |

### Memory

The `Option` type contains two variants, `None` and `Some`. The `None` variant contains no memory
data, however the `Some` variant contains a [`MemoryPointer`](ch02-04-memory-pointer.md) over an
unstructured slice of memory.

## API

### Free Functions

#### isSome

Returns `1` if the `Option` is of the `Some` variant, otherwise `0`.

```solidity
function isSome(Option self) pure returns (Primitive);
```

#### isNone

Returns `1` if the `Option` is of the `None` variant, otherwise `0`.

```solidity
function isNone(Option self) pure returns (Primitive);
```

#### expect

Returns the underlying [`MemoryPointer`](ch02-04-memory-pointer.md) if the `Option` is of the
`Some` variant.

Reverts with a custom string if the `Option` is of the `None` variant.

```solidity
function expect(Option self, string memory message) pure returns (MemoryPointer);
```

#### unwrap

Returns the underlying [`MemoryPointer`](ch02-04-memory-pointer.md) if the `Option` is of the
`Some` variant.

Reverts with [`IsNone`](#isnone-1) if the `Option` is of the `None` variant.

```solidity
function unwrap(Option self) pure returns (MemoryPointer);
```

#### unwrapOr

Returns the underlying [`MemoryPointer`](ch02-04-memory-pointer.md) if the `Option` is of the `Some`
variant.

Returns a custom, default [`MemoryPointer`](ch02-04-memory-pointer.md) if the `Option` is of the
`None` variant.

```solidity
function unwrapOr(Option self, MemoryPointer defaultValue) pure returns (MemoryPointer);
```

#### unwrapOrElse

Returns the underlying [`MemoryPointer`](ch02-04-memory-pointer.md) if the `Option` is of the `Some`
variant.

Returns the result of a custom function deriving a default
[`MemoryPointer`](ch02-04-memory-pointer.md) if the `Option` is of the `None` variant.

```solidity
function unwrapOrElse(
    Option self,
    function() pure returns (MemoryPointer) fn
) pure returns (MemoryPointer);
```

#### unwrapUnchecked

Returns the underlying [`MemoryPointer`](ch02-04-memory-pointer.md) without checking if the `Option`
is `None`.

```solidity
function unwrapUnchecked(Option self) pure returns (MemoryPointer);
```

#### asPrimitive

Converts an `Option` to [`Primitive`](ch02-01-primitive.md), performing no checks or mutations.

```solidity
function asPrimitive(Option self) pure returns (Primitive);
```

### LibOption

#### None

Constructs an `Option` of the `None` variant.

```solidity
function None() pure returns (Option);
```

#### Some

Constructs an `Option` of the `Some` variant with an underlying
[`MemoryPointer`](ch02-04-memory-pointer.md).

```solidity
function Some(MemoryPointer ptr) pure returns (Option);
```

#### asOption

Converts a [`Primitive`](ch02-01-primitive.md) to `Option`, performing no checks or mutations.

Intended to be used as a type-checker bypass, this is not the proper way to construct a new
`Option`.

```solidity
function asOption(Primitive self) pure returns (Option);
```

### OptionConstants

#### ENUM_MASK

1 bit mask, retains the `Member` enumeration.

```solidity
Primitive constant ENUM_MASK = Primitive.wrap(0x01);
```

#### PTR_MASK

64 bit mask, retains all bits of [`MemoryPointer`](ch02-04-memory-pointer.md).

```solidity
Primitive constant PTR_MASK = Primitive.wrap(0xffffffffffffffff);
```

#### ENUM_OFFSET

Bit offset of `member` in the stack value.

```solidity
Primitive constant ENUM_OFFSET = Primitive.wrap(64);
```

### OptionError

#### IsNone

Thrown when `unwrap` is called on an `Option` of the `None` variant.

```solidity
error IsNone();
```

## Assumptions

- A [`Primitive`](ch02-01-primitive.md) converted to `Option` is properly constrained before calling [`asOption`](#asoption).
- `unwrapUnchecked` is called only after performing the necessary checks.
