// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MultiSigWallet {
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public numConfirmationsRequired;

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        uint numConfirmations;
    }

    mapping(uint => mapping(address => bool)) public isConfirmed;

    Transaction[] public transactions;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint txIndex) {
        require(txIndex < transactions.length, "tx does not exist");
        _;
    }

    modifier notExecuted(uint txIndex) {
        require(!transactions[txIndex].executed, "tx already executed");
        _;
    }

    modifier notConfirmed(uint txIndex) {
        require(!isConfirmed[txIndex][msg.sender], "tx already confirmed");
        _;
    }

    constructor(address[] memory _owners, uint _numConfirmationsRequired) {
        require(_owners.length > 0, "owners required");
        require(
            _numConfirmationsRequired > 0 &&
            _numConfirmationsRequired <= _owners.length,
            "invalid number of required confirmatios"
        );

        for(uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        numConfirmationsRequired = _numConfirmationsRequired;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function submitTransaction(address _to, uint _value, bytes memory _data) public onlyOwner {
        uint txIndex = transactions.length;
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            numConfirmations: 0
        }));

        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }

    function confirmTransaction(uint txIndex) public onlyOwner txExists(txIndex) notExecuted(txIndex) notConfirmed(txIndex) {
        Transaction storage transaction = transactions[txIndex];
        transaction.numConfirmations += 1;
        isConfirmed[txIndex][msg.sender] = true;

        emit ConfirmTransaction(msg.sender, txIndex);
    }

    function executeTransaction(uint txIndex) public onlyOwner txExists(txIndex) notExecuted(txIndex) {
        Transaction storage transaction = transactions[txIndex];
        require(transaction.numConfirmations >= numConfirmationsRequired, "cannot execute tx");
        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "tx failed");

        emit ExecuteTransaction(msg.sender, txIndex);
    }

    function revokeConfirmation(uint txIndex) public onlyOwner txExists(txIndex) notExecuted(txIndex) {
        Transaction storage transaction = transactions[txIndex];
        require(isConfirmed[txIndex][msg.sender], "tx not confirmed");
        
        transaction.numConfirmations -= 1;
        isConfirmed[txIndex][msg.sender] = false;

        emit RevokeConfirmation(msg.sender, txIndex);
    }

    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    function getTransactionCount() public view returns (uint) {
        return transactions.length;
    }

    function getTransaction(uint txIndex) public view returns (
        address to, uint value,
        bytes memory data, bool executed, uint numConfirmations
    ) {
        Transaction storage transaction = transactions[txIndex];
        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations
        );
    }

    event Deposit(address indexed sender, uint amount, uint balance);
    event SubmitTransaction(address indexed owner, uint indexed txIndex, address indexed to, uint value, bytes data);
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);
}

contract TestContract {
    uint public i;

    function callMe(uint j) public {
        i += j;
    }

    function getData() public pure returns (bytes memory) {
        return abi.encodeWithSignature("callMe(uint256)", 123);
    }
}