pragma solidity ^0.8.13;

contract Mono {
    address public owner;
    string public model;
    address public mono_addr;

    constructor(address o, string memory m) payable {
        owner = o;
        model = m;
        mono_addr = address(this);
    }
}

contract Factory {
    Mono[] public monos;

    function create(address o, string calldata m) public {
        Mono mono = new Mono(o, m);
        monos.push(mono);
    }

    function createAndSendEther(address o, string calldata m) public payable {
        monos.push((new Mono){value: msg.value}(o, m));
    }

    function create2(address o, string calldata m, bytes32 s) public {
        monos.push((new Mono){salt: s}(o, m));
    }

    function getMono(uint i) public view returns (address, string memory, address, uint) {
        Mono mono = monos[i];

        return (mono.owner(), mono.model(), mono.mono_addr(), address(mono).balance);
    }
}