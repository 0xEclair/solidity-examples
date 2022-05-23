// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract DataLocation {
    uint[] arr;
    mapping(uint => address) map;
    struct A {
        uint foo;
    }
    mapping(uint => A) public As;

    function f() public {
        As[1] = A({foo: 5});
        _f(arr, map, As[1]);

        A storage a = As[1];
        A memory mem_a = A(0);
    }

    function _f(
        uint[] storage arr, 
        mapping(uint => address) storage map, 
        A storage a
    ) internal {
        a.foo -= 1;
    }

    function g(uint[] memory arr) public view returns (uint[] memory) {
        return arr;
    }

    function h(uint[] calldata arr) public view returns (uint[] memory) {
        return arr;
    }
}