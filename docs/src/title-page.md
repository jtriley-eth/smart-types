# Smart Types

Smart Types is an exploration of creating a new types library in the
[Solidity](https://docs.soliditylang.org/) programming language.

The library is primarily constructed from a single, core type, the `Primitive`. The `Primitive` is
built on a principle of minimizing implicit behavior. Range constraints, arithmetic, and type
casting are unchecked in contrast with Solidity's implicit behaviors. This requires intimate
awareness from the developer of the intended behavior and limitations of their system.

A single, unified core type also enabled generalized libraries and data types building on the same
principles. Instead of writing libraries that can target all of Solidity's signed and unsigned
integers, fixed point decimal numbers, fixed byte sizes, booleans, and addresses, we can write
libraries that target the `Primitive` so long as every type may be converted freely too and from it.

Additionally, memory interactions are reworked, built on the `Box`, a stack value
containing metadata about a slice of the Ethereum Virtual Machine's linear memory. We can generalize
memory interactions and wrap the `Box` in more complex types, adding new functionality to
target individual use cases.

This book serves as a philosophical document on the new type system, documentation for the existing
types, and as a schematic for constructing new types in a common methodology.
