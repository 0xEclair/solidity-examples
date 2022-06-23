pragma solidity ^0.8.13;

contract Factory {
    function deploy(address owner, uint value, bytes32 s) public payable returns (address) {
        return address(new C{salt: s}(owner, value));
    }
}

contract OldFactory {
    event Deployed(address addr, uint salt);

    function getBytecode(address owner, uint value) public pure returns (bytes memory) {
        bytes memory bytecode = type(C).creationCode;

        return abi.encodePacked(bytecode, abi.encode(owner, value));
    }

    function getAddress(bytes memory bytecode, uint _salt) public view returns (address) {
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode)));
        return address(uint160(uint(hash)));
    }

    function deploy(bytes memory bytecode, uint _salt) public payable {
        address addr;
        assembly {
            addr := create2(
                callvalue(),
                add(bytecode, 0x20),
                mload(bytecode),
                _salt
            )

            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }

        emit Deployed(addr, _salt);
    }
}

contract C {
    address public owner;
    uint public value;

    constructor(address o, uint v) payable {
        owner = o;
        value = v;
    }

    function balance() public view returns (uint) {
        return address(this).balance;
    }
}