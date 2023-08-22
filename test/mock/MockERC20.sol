// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockERC20 {
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    string public name = "test token";
    string public symbol = "test";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;
    mapping(address owner => uint256) public balanceOf;
    mapping(address owner => mapping(address spender => uint256)) public allowance;

    constructor() {
        balanceOf[msg.sender] = 1;
        totalSupply = 1;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        if (msg.sender != from) allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
}
