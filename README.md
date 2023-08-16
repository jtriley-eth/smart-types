# Smart Types

A rewrite of the solc type system using custom data types, minimizing implicit behavior.

Documentation will follow upon the official `0.1.0` release.

## TLDR;

- `Primitive` is the core, 32 byte type
- `Primitive` arithmetic is all unchecked by default with checked methods available
- `Primitive` casting via `as<type>` and `asPrimitive` syntax supported for all types
  - this performs no runtime bound checks
- `Primitive` bounds may be checked by `retainBits` or `constrainBits`, the latter reverting on fail
- `SmartPointer` is a core, 32 byte type, it occupies the 64 least significant bits
- `SmartPointer` contains a memory pointer and length, allocated in `LibSmartPointer`
- `Option` is an optional `SmartPointer`, a proper sum-type
- `Option` may resolve to `None` or `Some(SmartPointer)`
- `Option` API follows roughly Rust's

## TODO

- `Fn` type for runtime partial function application (in progress)
- `Vec` type for memory vectors (in progress)
- `ERCN` type around `address` for optimized ERC-related interactions without interfaces (todo)
- `Graph` recursive type for on-chain graph data structures (todo)

## Contributing

Contribution guide will follow upon the official `0.1.0` release.
