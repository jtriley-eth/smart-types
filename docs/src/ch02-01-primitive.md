# Primitive

## Overview

The `Primitive` is the core of the whole library. We define `Primitive` as a `uint256` alias with
unchecked type conversion using `asPrimitive` and `as<typename>` methods.

```solidity
uint256 a;
uint8 b;
bool c;
address d;

a.asPrimitive().asUint8();
b.asPrimitive().asBool();
c.asPrimitive().asAddress();
d.asPrimitive().asUint256();
```

Arithmetic is unchecked by default using operator overloading, checked methods are provided with the
naming convention of `<operation>Checked`, which revert on overflow, underflow, or division by zero.

```solidity
Primitive a;
Primitive b;

a + b;
a.add(b);
a.addChecked(b);
// ...
```

We also provide arithmetic operations for `Primitive` types intended to be interpreted as two's complement signed integers.

```solidity
Primitive a = int256(-1).asPrimitive();
Primitive b = int8(-2).asPrimitive();

a.signedDiv(b);
a.signedDivChecked(b);
```

We define bitwise operations with operator overloading when supported.

> Note: At the time of writing, shifting via `>>` and `<<` are not supported with operator
> overloading so shifting is only available via `shr` and `shl` methods.

```solidity
Primitive a;
Primitive b;

a & b;
a.and(b);
```

We define logical operations `truthy`, `falsy`, and `logicalNot` which collapse `Primitive` values
into either one or zero, values interpretable as booleans. Truthy values are defined as non-zero
`Primitive` values.

```solidity
Primitive iffy;

iffy.truthy();
iffy.falsy();
iffy.logicalNot();

if (iffy.truthy().asBool()) {
    // ...
}
```

## Layout

### Stack

The `Primitive` value on the stack occupies all 256 bits. There is no additional metadata packed
into the value.

| Primitive |
| --------- |
| 256 bits  |

## API

### Free Functions

#### eq

Returns `1` if `lhs` and `rhs` are equal, otherwise `0`.

```solidity
function eq(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### neq

Returns `0` if `lhs` and `rhs` are equal, otherwise `1`.

```solidity
function neq(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### gt

Returns `1` if `lhs` is greater than `rhs`, otherwise `0`.

```solidity
function gt(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### signedGt

Returns `1` if `lhs` is greater than `rhs`, otherwise `0`.

Operands are treated as two's complement signed integers.

```solidity
function signedGt(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### lt

Returns `1` if `lhs` is less than `rhs`, otherwise `0`.

```solidity
function lt(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### signedLt

Returns `1` if `lhs` is less than `rhs`, otherwise `0`.

Operands are treated as two's complement signed integers.

```solidity
function signedLt(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### add

Returns the sum of the two operands.

Overflow does not revert.

Overloads the `+` operator.

```solidity
function add(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### addChecked

Returns the sum of the two operands.

Overflow reverts with [`PrimitiveError.Overflow`](#overflow).

```solidity
function addChecked(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### sub

Returns the remainder of the two operands.

Underflow does not revert.

Overloads the `-` operator.

```solidity
function sub(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### subChecked

Returns the remainder of the two operands.

Underflow reverts with [`PrimitiveError.Underflow`](#underflow).

```solidity
function subChecked(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### mul

Returns the product of the two operands.

Overflow does not revert.

Overloads the `*` operator.

```solidity
function mul(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### mulChecked

Returns the product of the two operands.

Overflow reverts with [`PrimitiveError.Overflow`](#overflow).

...

```solidity
function mulChecked(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### div

Returns the quotient of the two operands.

Division by zero returns zero without reverting.

Overloads the `/` operator.

```solidity
function div(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### divChecked

Returns the quotient of the two operands.

Division by zero reverts with [`PrimitiveError.DivisionByZero`](#divisionbyzero).

```solidity
function divChecked(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### signedDiv

Returns the quotient of the two operands.

Division by zero returns zero without reverting.

Operands are treated as two's complement signed integers.

```solidity
function signedDiv(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### signedDivChecked

Returns the quotient of the two operands.

Division by zero reverts with [`PrimitiveError.DivisionByZero`](#divisionbyzero).

Operands are treated as two's complement signed integers.

```solidity
function signedDivChecked(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### mod

Returns the modulus of the two operands.

Modulo by zero returns zero without reverting.

Overloads the `%` operator.

```solidity
function mod(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### modChecked

Returns the modulus of the two operands.

Modulo by zero reverts with [`PrimitiveError.DivisionByZero`](#divisionbyzero).

```solidity
function modChecked(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### signedMod

Returns the modulus of the two operands.

Modulo by zero returns zero without reverting.

Operands are treated as two's complement signed integers.

```solidity
function signedMod(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### signedModChecked

Returns the modulus of the two operands.

Modulo by zero reverts with [`PrimitiveError.DivisionByZero`](#divisionbyzero).

Operands are treated as two's complement signed integers.

```solidity
function signedModChecked(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### addMod

Returns the modulus of the sum of the first two operands.

Modulo by zero returns zero without reverting.

```solidity
function addMod(Primitive lhs, Primitive rhs, Primitive modulus) pure returns (Primitive);
```

#### addModChecked

Returns the modulus of the sum of the first two operands.

Modulo by zero reverts with [`PrimitiveError.DivisionByZero`](#divisionbyzero).

```solidity
function addModChecked(Primitive lhs, Primitive rhs, Primitive modulus) pure returns (Primitive);
```

#### mulMod

Returns the modulus of the product of the first two operands.

Modulo by zero returns zero without reverting.

```solidity
function mulMod(Primitive lhs, Primitive rhs, Primitive modulus) pure returns (Primitive);
```

#### mulModChecked

Returns the modulus of the product of the first two operands.

Modulo by zero reverts with [`PrimitiveError.DivisionByZero`](#divisionbyzero).

...

```solidity
function mulModChecked(Primitive lhs, Primitive rhs, Primitive modulus) pure returns (Primitive);
```

#### exp

Returns the result of exponentiation of the two operands.

Overflow does not revert.

```solidity
function exp(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### isZero

Returns `1` if the value is zero, otherwise `0`.

```solidity
function isZero(Primitive self) pure returns (Primitive);
```

#### nonZero

Returns `1` if the value is non-zero, otherwise `0`.

```solidity
function nonZero(Primitive self) pure returns (Primitive);
```

#### extendSign

Extends the sign bit of a value from a given `bits` size to the remaining bits.

```solidity
function extendSign(Primitive self, Primitive bits) pure returns (Primitive);
```

#### shr

Returns the first operand right shifted by the second operand, in bits.

Bits that underflow are lost.

```solidity
function shr(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### shl

Returns the first operand left shifted by the second operand, in bits.

Bits that overflow are lost.

```solidity
function shl(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### rotr

Returns the first operand right shifted by the second operand, in bits.

Bits that underflow wrap around to the upper bits

```solidity
function rotr(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### rotl

Returns the first operand left shifted by the second operand, in bits.

Bits that overflow wrap around to the upper bits.

```solidity
function rotl(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### and

Returns the bitwise AND result of the two operands.

Overloads the `&` operator.

```solidity
function and(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### or

Returns the bitwise OR result of the two operands.

Overloads the `|` operator.

```solidity
function or(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### xor

Returns the bitwise XOR result of the two operands.

Overloads the `^` operator.

```solidity
function xor(Primitive lhs, Primitive rhs) pure returns (Primitive);
```

#### not

Returns the bitwise NOT of the operand.

Overloads the `~` operator.

```solidity
function not(Primitive self) pure returns (Primitive);
```

#### retainBits

Returns the first operand, retaining a number of bits indicated by the second operand.

```solidity
function retainBits(Primitive self, Primitive bits) pure returns (Primitive);
```

#### constraintBits

Returns the first operand. Reverts if a bit higher than the second operand is set.

```solidity
function constrainBits(Primitive self, Primitive bits) pure returns (Primitive);
```

#### getByte

Returns a byte from the first operand at the index indicated by the second operand.

Behaves in the same way as the `byte` instruction.

```solidity
function getByte(Primitive self, Primitive index) pure returns (Primitive);
```

#### truthy

Returns `1` if the value is non-zero, otherwise `0`.

```solidity
function truthy(Primitive self) pure returns (Primitive);
```

#### falsy

Returns `1` if the value is zero, otherwise `0`.

```solidity
function falsy(Primitive self) pure returns (Primitive);
```

#### logicalNot

Returns `1` if the value is zero, otherwise `0`.

Functionally identical to [`falsy`](#falsy).

```solidity
function logicalNot(Primitive self) pure returns (Primitive);
```

### PrimitiveConstants

#### ZERO

Primitive `0`.

```solidity
Primitive constant ZERO = Primitive.wrap(0);
```

#### ONE

Primitive `1`.

```solidity
Primitive constant ONE = Primitive.wrap(1);
```

#### BYTE_SIZE

Primitive `32`.

```solidity
Primitive constant BYTE_SIZE = Primitive.wrap(32);
```

#### BIT_SIZE

Primitive `256`.

```solidity
Primitive constant BIT_SIZE = Primitive.wrap(256);
```

#### MAX

Primitive `type(uint256).max`.

```solidity
Primitive constant MAX = Primitive.wrap(type(uint256).max);
```

### PrimitiveAs

#### asPrimitive(bool)

Converts a `bool` to `Primitive`, `true` becomes `1`, `false` becomes `0`.

```solidity
function asPrimitive(bool self) pure returns (Primitive);
```

#### asPrimitive(address)

Converts an `address` to `Primitive`, the value is right-aligned.

```solidity
function asPrimitive(address self) pure returns (Primitive);
```

#### asPrimitive(address payable)

Converts an `address payable` to `Primitive`, the value is right-aligned.

```solidity
function asPrimitive(address payable self) pure returns (Primitive);
```

#### asPrimitive(uint256)

Converts a `uint256` to `Primitive`.

All unsigned integers are implicitly up-casted to `uint256` when calling this function.

```solidity
function asPrimitive(uint256 self) pure returns (Primitive);
```

#### asPrimitive(int256)

Converts an `int256` to `Primitive`.

All signed integers are implicitly up-casted to `i256` when calling this function.

```solidity
function asPrimitive(int256 self) pure returns (Primitive);
```

#### asPrimitive(bytes32)

Converts a `bytes32` value to `Primitive`.

All `bytesN` types are up-casted to `bytes32` when calling this function. Any `bytesN` types smaller
than 32 are left-aligned.

```solidity
function asPrimitive(bytes32 self) pure returns (Primitive);
```

### From

The `From` library is globally applied to `Primitive`, enabling explicit type casting using the 'as'
function naming convention.

No checks are performed when type casting and no type casts revert due to overflow.

### PrimitiveError

#### Overflow

Thrown when a checked arithmetic operation overflows.

```solidity
error Overflow();
```

#### Underflow

Thrown when a checked arithmetic operation underflows.

```solidity
error Underflow();
```

#### DivisionByZero

Thrown when a checked arithmetic operation contains a division by zero.

```solidity
error DivisionByZero();
```

## Assumptions

- Down-casting from `Primitive` to a smaller type is checked, masked, or invariably within the smaller type's range
