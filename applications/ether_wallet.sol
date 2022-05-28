// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {

    }

    function withdraw(uint amount) public {
        require(msg.sender == owner, "msg.sender is not owner");
        payable(msg.sender).transfer(amount);
    }

    function balance() public view returns (uint) {
        return address(this).balance;
    }
}