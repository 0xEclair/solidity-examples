// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract FunctionModifier {
    address public owner;
    uint public x = 10;
    bool public locked;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier validAddress(address addr) {
        require(addr != address(0), "not valid address");
        _;
    }

    function hello() public onlyOwner validAddress(msg.sender) {

    }

    modifier noReentrancy() {
        require(!locked, "no");

        locked = true;
        _;
        locked = false;
    }

    function decrement(uint i) public noReentrancy {
        x -= i;
        if(i > 1){
            decrement(i - 1);
        }
    }
}