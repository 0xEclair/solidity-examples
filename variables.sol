// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Variables {
    string public text = "hello";
    uint public num = 123;

    function doSomething() public {
        uint i = 256;
        uint timestamp = block.timestamp;
        address sender = msg.sender;
        emit didSomething(sender);
    }

    event didSomething(address sender);
}