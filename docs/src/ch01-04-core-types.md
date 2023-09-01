# Core Types

This document provides a brief summary of each data type in the library.

- [`Primitive`](ch02-01-primitive.md): Generic 256 bit type at the core of the library
- [`CalldataPointer`](ch02-02-calldata-pointer.md): Generic pointer to calldata
- [`CodePointer`](ch02-03-code-pointer.md): Generic pointer to local bytecode
- [`MemoryPointer`](ch02-04-memory-pointer.md): Generic pointer to memory
- [`ReturndataPointer`](ch02-05-returndata-pointer.md): Generic pointer to returndata
- [`StoragePointer`](ch02-06-returndata-pointer.md): Generic pointer to persistent storage
- [`SmartPointer`](ch02-07-smart-pointer.md): Generic metadata of a slice of memory
- [`Option`](ch02-08-option.md): Nullable sum type containing either nothing or a smart pointer
- [`ERCN`](ch02-09-ercn.md): Family of efficient, drop-in interface replacements
  - [`ERC20`](https://eips.ethereum.org/EIPS/eip-20): Token Standard
- [`Fn`](ch02-10-fn.md): Generic, lazy evaluated, partially applicable function
