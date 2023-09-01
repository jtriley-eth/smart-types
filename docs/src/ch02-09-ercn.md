# ERCN

The `ERCN` family of types encompasses commonly called contracts conforming to interfaces defined
in Ethereum Request for Comment (ERC) standards. The defacto standard for calling methods on
external contracts in modern Solidity is through an `interface`. The interface contains all methods
to be called on the external contract and is converted into an Application Binary Interface (ABI)
encoding function at compile time. We define custom types wrapping the `address` type, providing a
one-to-one, drop-in replacement for interfaces.

Each contains its own type conversion methods to and from both `address` and `Primitive`.

## Layout

### Stack

Each `ERCN` type occupies 160 bits. No additional data is packed into the stack value.

| empty   | address  |
| ------- | -------- |
| 96 bits | 160 bits |

## API

### ERC20

#### name

Calls the name function.

```solidity
function name(ERC20 self) view returns (string memory);
```

#### symbol

Calls the symbol function.

```solidity
function symbol(ERC20 self) view returns (string memory);
```

#### decimals

Calls the decimals function.

```solidity
function decimals(ERC20 self) view returns (uint256);
```

#### totalSupply

Calls the totalSupply function.

```solidity
function totalSupply(ERC20 self) view returns (uint256);
```

#### balanceOf

Calls the balanceOf function.

```solidity
function balanceOf(ERC20 self, address owner) view returns (uint256);
```

#### allowance

Calls the allowance function.

```solidity
function allowance(ERC20 self, address owner, address spender) view returns (uint256);
```

#### transfer

Calls the transfer function.

```solidity
function transfer(ERC20 self, address to, uint256 amount) returns (bool);
```

#### transferFrom

Calls the transferFrom function.

```solidity
function transferFrom(ERC20 self, address from, address to, uint256 amount) returns (bool);
```

#### approve

Calls the approve function.

```solidity
function approve(ERC20 self, address spender, uint256 amount) returns (bool);
```

## Assumptions

- The underlying `address` has code.
- The underlying `address` implements the correct `ERCN` interface.
