// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "lib/forge-std/src/Test.sol";
import "test/mock/MockERC20.sol";
import {ERC20, LibERC20} from "src/Prelude.sol";

contract ERC20Test is Test {
    using LibERC20 for address;

    ERC20 token;
    address alice = vm.addr(1);
    address bob = vm.addr(2);

    modifier asActor(address actor) {
        vm.startPrank(actor);
        _;
        vm.stopPrank();
    }

    function setUp() public {
        vm.prank(alice);
        token = address(new MockERC20()).asERC20();
    }

    function testName() public {
        assertEq(token.name(), "test token");
    }

    function testSymbol() public {
        assertEq(token.symbol(), "test");
    }

    function testDecimals() public {
        assertEq(token.decimals(), 18);
    }

    function testTotalSupply() public {
        assertEq(token.totalSupply(), 1);
    }

    function testBalanceOf() public {
        assertEq(token.balanceOf(alice), 1);
        assertEq(token.balanceOf(bob), 0);
    }

    function testAllowance() public {
        assertEq(token.allowance(alice, bob), 0);
    }

    function testTransfer() public asActor(alice) {
        assertEq(token.balanceOf(alice), 1);
        assertEq(token.balanceOf(bob), 0);
        token.transfer(bob, 1);
        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(bob), 1);
    }

    function testTransferFrom() public asActor(alice) {
        assertEq(token.balanceOf(alice), 1);
        assertEq(token.balanceOf(bob), 0);
        token.transferFrom(alice, bob, 1);
        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(bob), 1);
    }

    function testApprove() public asActor(alice) {
        assertEq(token.allowance(alice, bob), 0);
        token.approve(bob, 1);
        assertEq(token.allowance(alice, bob), 1);
    }

    function testFuzzTransfer(address to) public asActor(alice) {
        vm.assume(to != alice);
        assertEq(token.balanceOf(alice), 1);
        assertEq(token.balanceOf(to), 0);
        token.transfer(to, 1);
        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(to), 1);
    }

    function testFuzzTransferFrom(address from, address to) public {
        vm.assume(from != to);
        vm.prank(alice);
        token.transfer(from, 1);

        assertEq(token.balanceOf(from), 1);
        assertEq(token.balanceOf(to), 0);
        vm.prank(from);
        token.transferFrom(from, to, 1);
        assertEq(token.balanceOf(from), 0);
        assertEq(token.balanceOf(to), 1);
    }

    function testFuzzApprove(address owner, address spender) public asActor(owner) {
        assertEq(token.allowance(owner, spender), 0);
        token.approve(spender, 1);
        assertEq(token.allowance(owner, spender), 1);
    }
}
