// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Mapping {
    mapping(address => uint) map;

    function get() public view returns (uint) {
        return map[msg.sender];
    }

    function set(uint i) public {
        map[msg.sender] = i;
    }

    function remove() public {
        delete map[msg.sender];
    }
}

contract NestedMapping {
    mapping(address => mapping(uint => bool)) public nested;

    function get(uint i) public view returns (bool) {
        return nested[msg.sender][i];
    }

    function set(uint i, bool b) public {
        nested[msg.sender][i] = b;
    }

    function remove(uint i) public {
        delete nested[msg.sender][i];
    }
}