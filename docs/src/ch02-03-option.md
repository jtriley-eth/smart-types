# Option

## Overview

The `Option` type is a sum type, with members `None` with no data or `Some` with a `SmartPointer` to
the underlying data. It may be created using `LibOption` with the appropriate function.

```solidity
Option maybeSomething = LibOption.Some(smartPtr);
Option definitelyNothing = LibOption.None();
```

The underlying `SmartPointer` should only be accessed by a method that handles the members first.
We can revert on `None` with or without a custom message, and we can provide either a default value
or a function that constructs a default value.

```solidity
Option a;

a.expect("error: no data");
a.unwrapOrElse(newSmartPointer);
```

## Layout

### Stack

The `Option` value on the stack occupies 72 bits. There is a 64 bit
[`SmartPointer`](ch02-02-smart-pointer.md) packed with an eight bit `Member` enumeration.

The `Member` enumeration is not exported externally, as it should never be accessed directly. It
represents either `None` or `Some`, where `Some` is accompanied by a `SmartPointer` while `None` is
not.

| empty    | Member | SmartPointer |
| -------- | ------ | ------------ |
| 184 bits | 8 bits | 64 bits      |

### Memory

The `Option` type contains two variants, `None` and `Some`. The `None` variant contains no memory
data, however the `Some` variant contains a `SmartPointer` over an unstructured slice of memory. For
more information about memory in the context of the `SmartPointer`, refer to its
[documentation](ch02-02-smart-pointer.md).

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

Returns the underlying `SmartPointer` if the `Option` is of the `Some` variant.

Reverts with a custom string if the `Option` is of the `None` variant.

```solidity
function expect(Option self, string memory message) pure returns (SmartPointer);
```
#### unwrap

Returns the underlying `SmartPointer` if the `Option` is of the `Some` variant.

Reverts with [`OptionError.IsNone`](#isnone-1) if the `Option` is of the `None` variant.

```solidity
function unwrap(Option self) pure returns (SmartPointer);
```
#### unwrapOr

Returns the underlying `SmartPointer` if the `Option` is of the `Some` variant.

Returns a custom, default `SmartPointer` if the `Option` is of the `None` variant.

```solidity
function unwrapOr(Option self, SmartPointer defaultValue) pure returns (SmartPointer);
```
#### unwrapOrElse

Returns the underlying `SmartPointer` if the `Option` is of the `Some` variant.

Returns the result of a custom function deriving a default `SmartPointer` if the `Option` is of the
`None` variant.

```solidity
function unwrapOrElse(
    Option self,
    function() pure returns (SmartPointer) fn
) pure returns (SmartPointer);
```
#### asPrimitive

Converts an `Option` to `Primitive`, performing no checks or mutations.

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

Constructs an `Option` of the `Some` variant with an underlying `SmartPointer`.

```solidity
function Some(SmartPointer ptr) pure returns (Option);
```

#### asOption

Converts a `Primitive` to `Option`, performing no checks or mutations.

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

#### SMART_POINTER_MASK

64 bit mask, retains all bits of `SmartPointer`.

```solidity
Primitive constant SMART_POINTER_MASK = Primitive.wrap(0xffffffffffffffff);
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

- A `Primitive` converted to `Option` is properly constrained before calling [`asOption`](#asoption).
