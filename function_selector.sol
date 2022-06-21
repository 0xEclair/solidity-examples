pragma solidity ^0.8.13;

contract FunctionSelector {
    function getSelector(string calldata func) public pure returns (bytes4) {
        return bytes4(keccak256(bytes(func)));
    }
}