# Basic Usage

To demonstrate the usage of this library, we will write a simple example taking advantage of the
`Primitive`, `Box`, and `Option` types.

The `Option` type is a sum type representing a nullable value, it may be either `None` or `Some`, if
its value is `Some`, then it must also contain some underlying data.

We define a contract that attempts to fetch an address's codehash. If the address has no code, we
revert with "invalid".

## Full Example

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@smart-types/Prelude.sol";
using PrimitiveAs for bytes32;

contract HashFetcher {
    function readCodehash(address target) public returns (bytes32) {
        return getCodehash(target)
            .expect("invalid")
            .read()
            .asBytes32();
    }
}

function getCodehash(address target) pure returns (Option) {
    if (target.code.length == 0) return LibOption.None();
    return LibOption.Some(
        LibBox.mstore(target.codehash.asPrimitive())
    );
}
```

## Breakdown

First, we define a `getCodehash` function that takes an address, `target`, and returns an `Option`
type. If an address has no code, its codehash is zero. So on first we get the `hash` by calling
`target.codehash` and converting it to `Primitive` with the zero cost `asPrimitive` abstraction.

We check if the `hash` is zero with the `isZero` method, using another zero cost `asBool`
abstraction for compatibility with Solidity's built-in `if` statement. If it is nullish, we return
`None()` from the `LibOption` library.

If the `hash` is nonzero, we write it to a `Box`, which can then be wrapped in the `Some`
variant of the `Option` type.

> Note: Using `asPrimitive()` on Solidity's elementary data types requires a 'using' directive in
> the same scope:
>
> `using PrimitiveAs for <typename>;`

```solidity
// -- snip --

import "@smart-types/Prelude.sol";
using PrimitiveAs for bytes32;

// -- snip --

function getCodehash(address target) pure returns (Option) {
    Primitive hash = target.codehash.asPrimitive();
    if (hash.isZero().asBool()) return LibOption.None();
    return LibOption.Some(LibBox.mstore(hash));
}

// -- snip --
```

Next, we can use this new function in our final contract, but note that in returning an `Option`,
implementors must handle it before using the underlying data.

> Note: Solidity does not enforce this, its type system can be fully subverted, but excluding type
> system subversion, types such as `Option` must be handled before using the underlying data.


The `Option` type includes an `expect` method that reverts with a custom error string when the
variant is `None` and returns the `Box` if the variant is `Some(Box)`. If `expect`
does not revert, we have a `Box`, so we read from it using the `read` method. This gives us
the underlying data, but it is of type `Primitive`. Since our `readCodehash` method returns
`bytes32`, we can simply use the zero cost `asBytes32` method.

```solidity
// -- snip --

contract HashFetcher {
    function readCodehash(address target) public returns (bytes32) {
        return getCodehash(target)
            .expect("invalid")
            .read()
            .asBytes32();
    }
}

// -- snip --
```

## Rationale

If this seems like a lot of boilerplate for such a seemingly trivial task, it is. Smart types are
built for large systems requiring correctness, not fetching code hashes. Consider an order book
where `Option` wraps what may or may not be an order to process. Consider a liquidity position in an
automated market maker that may or may not exist.

These types are generalized, they may be used for a wide array of use cases. Next up we will explore
a bit more in depth the philosophy of the type system.
