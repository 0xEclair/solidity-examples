// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Fallback {
    event Log(uint gas);

    fallback() external payable {
        emit Log(gasleft());
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract SendToFallback {
    function transferToFallback(address payable to) public payable {
        to.transfer(msg.value);
    }

    function callFallback(address payable to) public payable {
        (bool sent, ) = to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}