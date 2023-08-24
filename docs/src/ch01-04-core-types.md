# Core Types

This document provides a brief overview of each data type in the library, its design philosophy, and
links to more in depth documentation.

## [`Primitive`](ch02-01-primitive.md)

The `Primitive` is the core of the whole library. We define `Primitive` as a `uint256` alias with
unchecked type consversion using `asPrimitive` and `as<typename>` methods.

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

Arihmetic is unchecked by default using operator overloading, checked methods are provided with the naming convention of `<operation>Checked`, which revert on overflow, underflow, or division by zero.

```solidity
Primitive a;
Primitive b;

a + b;
a - b;
a * b;
a / b;
a % b;
a.addChecked(b);
a.subchecked(b);
a.mulChecked(b);
a.divChecked(b);
a.modChecked(b);
// ...
```

We also provide arithmetic operations for `Primitive` types intended to be interpreted as two's complement signed integers.

```solidity
Primitive a = int256(-1).asPrimitive();
Primitive b = int8(-2).asPrimitive();

a.signedDiv(b);
a.signedDivChecked(b);
a.signedMod(b);
a.signedModCheckd(b);
```

We define bitwise operations with operator overloading when supported, at the time of writing,
shifting via `>>` and `<<` are not supported with operator overloading.

```solidity
Primitive a;
Primitive b;

a & b;
a | b;
a ^ b;
~a;
a.and(b);
a.or(b);
a.xor(b);
a.not();
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

## [`SmartPointer`](ch02-02-smart-pointer.md)

The `SmartPointer` is a `uint256` value containing a pointer to memory and a length of the memory
segment, packed into a single stack value. It may be allocated directly or its pointer and length
provided from methods defined in `LibSmartPointer`. Additionally, it can be converted to and from a
`Primitive` with no checks or mutations using the 'as' convention.

```solidity
SmartPointer a = LibSmartPointer.malloc(size);
SmartPointer b = LibSmartPointer.toSmartPointer(pointer, length);
SmartPointer c = LibSmartPointer.writePrimitive(value);
SmartPointer d = c.reallocate(Primitive.wrap(64));
SmartPointer e = d.asPrimitive().asSmartPointer();
```

Both values in the `SmartPointer` may be read through the `pointer` and `length` methods.

```solidity
SmartPointer a = LibSmartPointer.malloc(size);

a.pointer();
a.length();
```

Data pointed to by the `SmartPointer` may be read or written, optionally from an additional offset,
and it may be hashed.

```solidity
Primitive one = Primitive.wrap(1);
Primitive two = Primitive.wrap(2);
SmartPointer a = LibSmartPointer.malloc(Primitive.wrap(64));

a.write(one);
a.writeAt(Primitive.wrap(32), two);

a.read();
a.readAt(Primitive.wrap(32));

a.hash();
```

## [`Option`](ch02-03-option.md)

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
a.unwrap();
a.unwrapOr(LibSmartPointer.malloc(Primitive.wrap(32)));
a.unwrapOrElse(newSmartPointer);
```

## [`ERCN`](ch02-04-ercn.md)

The `ERCN` family of types encompasses commonly called contracts conforming to interfaces defined
in Ethereum Request for Comment (ERC) standards. The defacto standard for calling methods on
external contracts in modern Solidity is through an `interface`. The interface contains all methods
to be called on the external contract and is converted into an Application Binary Interface (ABI)
encoding function at compile time. We define custom types wrapping the `address` type, providing a
one-to-one, drop-in replacement for interfaces. The list of currently implemented ERC standards are
as follows.

- [`ERC20`](https://eips.ethereum.org/EIPS/eip-20): Token Standard

Each contains its own type conversion methods to and from both `address` and `Primitive`.

```solidty
ERC20 token = addr.asERC20();

token.name();
token.symbol();
token.decimals();
token.totalSupply();
token.balanceOf(address(this));
token.allowance(address(this), msg.sender);
token.transfer(msg.sender, 1);
token.transferFrom(msg.sender, address(this), 1);
token.approve(msg.sender, 0);

token.asPrimitive();
```

## [`Fn`](ch02-05-fn.md)

The `Fn` type is a wrapper around Solidity's internal function type. Internal functions in Solidity
are 16 bit integers pointing to either a bytecode index or a function id if the Yul intermediate
representation is active. The `Fn` type can handle up to eight unique arguments and partial
application of arguments can create new functions altogether. Arguments are applied one at a time,
left to right. If more arguments are applied than the underlying function can handle, the `Fn` will
exceptionally halt at runtime. Arguments can also be of type `Primitive` or `Fn`; if the latter,
those functions may also be partially applied. Arguments are lazily evaluated, resolved only when
required by the `call` method.

```solidity
function mul(Primitive a, Primitive b) pure returns (Primitive) {
    return a * b;
}

Fn double = mul.toFn().applyArgument(two);
Fn triple = mul.toFn().applyArgument(three);

Primitive result = double.applyArgument(
    triple.applyArgument(four)
).call();
```

Information about the `Fn` can be obtained using a few functions.

```solidity
Fn f = mul.asFn();

f.destination();
f.kindBitmap();
f.appliedArguments();
f.expectedArguments();
f.argumentAt(index);
f.isConcreteAt(index);
f.isCallable();
```

A `Fn` may also be cloned where a new memory slice is allocated for arguments and all arguments are
copied to the new memory slice.

```solidity
Fn multiply = mul.asFn();
Fn alsoMultiply = multiply.clone();
```
