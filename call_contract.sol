pragma solidity ^0.8.13;

contract Callee {
    uint public x;
    uint public value;

    function setX(uint _x) public returns (uint) {
        x = _x;
        return x;
    }

    function setXandSendEther(uint _x) public payable returns (uint, uint) {
        x = _x;
        value = msg.value;

        return (x, value);
    }
}

contract Caller {
    function setX(Callee c, uint _x) public {
        uint x = c.setX(_x);
    }

    function setXWithAddress(address addr, uint _x) public {
        Callee c = Callee(addr);
        c.setX(_x);
    }

    function setXandEther(Callee c, uint _x) public payable {
        (uint x, uint value) = c.setXandSendEther{value: msg.value}(_x);
    }
}