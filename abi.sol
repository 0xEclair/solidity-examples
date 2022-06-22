pragma solidity ^0.8.13;

interface IERC20 {
    function transfer(address, uint) external;
}

contract Encode {
    function signature(address to, uint amount) external pure returns (bytes memory) {
        return abi.encodeWithSignature("transfer(address,uint256)", to, amount);
    }

    function selector(address to, uint amount) external pure returns (bytes memory) {
        return abi.encodeWithSelector(IERC20.transfer.selector, to, amount);
    }

    function call(address to, uint amount) external pure returns (bytes memory) {
        return abi.encodeCall(IERC20.transfer, (to, amount));
    }
}

contract Decode {
    struct Mono {
        string name;
        uint[2] nums;
    }

    function encode(uint x, address addr, uint[] calldata arr, Mono calldata m) external pure returns (bytes memory) {
        return abi.encode(x, addr, arr, m);
    }

    function decode(bytes calldata data) external pure returns (uint, address, uint[] memory, Mono memory) {
        return abi.decode(data, (uint, address, uint[], Mono));
    }
}