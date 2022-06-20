// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Payable {
    address payable public owner;
    mapping(address => uint256) public deposits;
    constructor() payable {
        owner = payable(msg.sender);
    }

    function deposit() public payable {
        deposits[msg.sender] += msg.value;
    }

    function notPayable() public {

    }

    function withdraw() public {
        uint256 amount = deposits[msg.sender];
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to send ether");
        deposits[msg.sender] = 0;
    }

    function transfer(address payable to, uint amount) public {
        require(deposits[msg.sender] >= amount, "invalid amount");
        deposits[msg.sender] -=amount;
        (bool success, ) = to.call{value: amount}("");
        require(success, "Failed to send ether");
    }
}