// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Immutable {
    address public immutable my_address;
    uint public immutable my_uint;

    constructor(uint num) {
        my_address = msg.sender;
        my_uint = num;
    }
}