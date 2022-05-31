// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Counter {
    uint public count;

    function increment() external {
        count += 1;
    }
}

interface ICounter {
    function count() external view returns (uint);

    function increment() external;
}

contract ContractImpl {
    function incrementCounter(address counter) external {
        ICounter(counter).increment();
    }

    function getCount(address counter) external view returns (uint) {
        return ICounter(counter).count();
    }
}