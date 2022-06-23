pragma solidity ^0.8.13;

interface IERC721 {
    function safeTransferFrom(address from, address to, uint tokenId) external;
    function transferFrom(address from, address to, uint tokenId) external;
}

contract Auction {
    IERC721 public nft;
    uint public tokenId;

    address payable public seller;
    uint public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    constructor(address _nft, uint _tokenId, uint _startingBid) {
        nft = IERC721(_nft);
        tokenId = _tokenId;

        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    function start() external {
        require(!started, "already started");
        require(seller == msg.sender, "not seller");

        nft.transferFrom(msg.sender, address(this), tokenId);
        started = true;
        endAt = block.timestamp + 1 days;
    }

    function bid() external payable {
        require(started, "waitting for started");
        require(block.timestamp < endAt, "already ended");
        require(msg.value > highestBid, "value < highest");

        if(highestBidder != address(0)) {
            bids[highestBidder] +=highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function withdraw() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);
    }

    function end() external {
        require(!ended, "ended");

        require(started, "not started");
        require(block.timestamp >= endAt, "not ended");

        ended = true;
        if(highestBidder != address(0)) {
            nft.safeTransferFrom(address(this), highestBidder, tokenId);
            seller.transfer(highestBid);
        }
        else {
            nft.safeTransferFrom(address(this), seller, tokenId);
        }
    }
}