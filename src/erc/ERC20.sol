// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";

type ERC20 is address;

using {
    name,
    symbol,
    decimals,
    totalSupply,
    balanceOf,
    allowance,
    transfer,
    transferFrom,
    approve
} for ERC20 global;

uint256 constant NAME_SELECTOR = 0x06fdde03;
uint256 constant SYMBOL_SELECTOR = 0x95d89b41;
uint256 constant DECIMALS_SELECTOR = 0x313ce567;
uint256 constant TOTAL_SUPPLY_SELECTOR = 0x18160ddd;
uint256 constant BALANCE_OF_SELECTOR = 0x70a08231;
uint256 constant ALLOWANCE_SELECTOR = 0xdd62ed3e;
uint256 constant TRANSFER_SELECTOR = 0xa9059cbb;
uint256 constant TRANSFER_FROM_SELECTOR = 0x23b872dd;
uint256 constant APPROVE_SELECTOR = 0x095ea7b3;

library LibERC20 {
    function asERC20(Primitive self) internal pure returns (ERC20) {
        return ERC20.wrap(self.asAddress());
    }

    function asERC20(address self) internal pure returns (ERC20) {
        return ERC20.wrap(self);
    }
}

function name(ERC20 self) view returns (string memory str) {
    assembly {
        mstore(0x00, NAME_SELECTOR)
        if iszero(staticcall(gas(), self, 0x1c, 0x04, 0x00, 0x00)) {
            revert(0x00, 0x00)
        }
        returndatacopy(0x00, 0x20, 0x40)
        let len := mload(0x00)

        str := mload(0x40)
        mstore(0x40, add(str, add(0x20, len)))
        mstore(str, len)
        returndatacopy(add(str, 0x20), 0x40, len)
    }
}

function symbol(ERC20 self) view returns (string memory str) {
    assembly {
        mstore(0x00, SYMBOL_SELECTOR)
        if iszero(staticcall(gas(), self, 0x1c, 0x04, 0x00, 0x00)) {
            revert(0x00, 0x00)
        }
        returndatacopy(0x00, 0x20, 0x40)
        let len := mload(0x00)

        str := mload(0x40)
        mstore(0x40, add(str, add(0x20, len)))
        mstore(str, len)
        returndatacopy(add(str, 0x20), 0x40, len)
    }
}

function decimals(ERC20 self) view returns (uint256 dec) {
    assembly {
        mstore(0x00, DECIMALS_SELECTOR)
        if iszero(staticcall(gas(), self, 0x1c, 0x04, 0x00, 0x20)) {
            revert(0x00, 0x00)
        }
        dec := mload(0x00)
    }
}

function totalSupply(ERC20 self) view returns (uint256 supply) {
    assembly {
        mstore(0x00, TOTAL_SUPPLY_SELECTOR)
        if iszero(staticcall(gas(), self, 0x1c, 0x04, 0x00, 0x20)) {
            revert(0x00, 0x00)
        }
        supply := mload(0x00)
    }
}

function balanceOf(ERC20 self, address owner) view returns (uint256 bal) {
    assembly {
        mstore(0x00, BALANCE_OF_SELECTOR)
        mstore(0x20, owner)
        if iszero(staticcall(gas(), self, 0x1c, 0x24, 0x00, 0x20)) {
            revert(0x00, 0x00)
        }
        bal := mload(0x00)
    }
}

function allowance(ERC20 self, address owner, address spender)
    view
    returns (uint256 amt)
{
    assembly {
        let free_mem_ptr := mload(0x40)
        mstore(0x00, ALLOWANCE_SELECTOR)
        mstore(0x20, owner)
        mstore(0x40, spender)
        if iszero(staticcall(gas(), self, 0x1c, 0x44, 0x00, 0x20)) {
            revert(0x00, 0x00)
        }
        mstore(0x40, free_mem_ptr)
        amt := mload(0x00)
    }
}

function transfer(ERC20 self, address to, uint256 amount) returns (bool ok) {
    assembly {
        let free_mem_ptr := mload(0x40)
        mstore(0x00, TRANSFER_SELECTOR)
        mstore(0x20, to)
        mstore(0x40, amount)
        if iszero(call(gas(), self, 0x00, 0x1c, 0x64, 0x00, 0x20)) {
            revert(0x00, 0x00)
        }
        mstore(0x40, free_mem_ptr)
        ok := mload(0x00)
    }
}

function transferFrom(ERC20 self, address from, address to, uint256 amount) returns (bool ok) {
    assembly {
        let free_mem_ptr := mload(0x40)
        mstore(0x00, TRANSFER_FROM_SELECTOR)
        mstore(0x20, from)
        mstore(0x40, to)
        mstore(0x60, amount)
        if iszero(call(gas(), self, 0x00, 0x1c, 0x84, 0x00, 0x20)) {
            revert(0x00, 0x00)
        }
        mstore(0x40, free_mem_ptr)
        mstore(0x60, 0x00)
        ok := mload(0x00)
    }
}

function approve(ERC20 self, address spender, uint256 amount) returns (bool ok) {
    assembly {
        let free_mem_ptr := mload(0x40)
        mstore(0x00, APPROVE_SELECTOR)
        mstore(0x20, spender)
        mstore(0x40, amount)
        if iszero(call(gas(), self, 0x00, 0x1c, 0x64, 0x00, 0x20)) {
            revert(0x00, 0x00)
        }
        mstore(0x40, free_mem_ptr)
        ok := mload(0x00)
    }
}
