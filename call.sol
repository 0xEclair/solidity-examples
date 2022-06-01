// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Receiver {
    event Received(address caller, uint amount, string message);

    fallback() external payable {
        emit Received(msg.sender, msg.value, "Fallback was called");
    }

    function foo(string memory message, uint x) public payable returns (uint) {
        emit Received(msg.sender, msg.value, message);

        return x + 1;
    }
}

contract Caller {
    event Response(bool success, bytes data);

    function testCallFoo(address payable addr) public payable {
        (bool success, bytes memory data) = addr.call{value: msg.value, gas: 5000}(
            abi.encodeWithSignature("foo(string,uint256)", "call foo", 123)
        );

        emit Response(success, data);
    }

    function testCallDoesNotExist(address addr) public {
        (bool success, bytes memory data) = addr.call(
            abi.encodeWithSignature("doesNotExist()")
        );

        emit Response(success, data);
    }
}