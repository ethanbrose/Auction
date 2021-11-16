// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 < 0.9.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

//import "./User.sol";
//import "./NFT.sol";


contract AuctionSystem {
    
    uint256 duration;
    address payable public immutable owner;
    
    IERC721 public nft;
    uint256 public nftID;
    
    uint256 public highestBid = 0;
    address public  highestBidder = 0x0000000000000000000000000000000000000000;
    
    
    //The constructor initializes many variables
    constructor (uint256 numDays, IERC721 _nft, uint256 _nftID) {
        owner = payable (msg.sender);
        duration = block.timestamp + (numDays * 1 days);
        nft = _nft;
        nftID = _nftID;
    }
    
    
    //regular old bid function
    function bid (uint256 curBid) public notEnded {
        if (curBid > highestBid) {
            highestBid = curBid;
            highestBidder = msg.sender;
        }
    }
    
    
    
    //if called, this function automatically bids a bid 5% larger than the current highest bid.
    function quickBid () public notEnded {
            highestBid = highestBid + (highestBid/20);
            highestBidder = msg.sender;
    }
    
    event Win (address _highestBidder, uint256 _highestBid);
    
    function winAuction () public payable ended {
        
        require (highestBidder != 0x0000000000000000000000000000000000000000, "Nobody has bid. You still have ownership of your NFT.");
        
        nft.safeTransferFrom (address(this), highestBidder, nftID);
        owner.transfer (highestBid);
        
        emit Win (highestBidder, highestBid);
        
        
    }
    
    //modifiers
    
    modifier notEnded () {
        require (block.timestamp < duration, "This auction has ended.");
        _;
    }
    
    modifier ended () {
        require (block.timestamp > duration, "This auction has not ended.");
        _;
    }
    
    //getter section
    
    function getDuration () public view returns (uint256) {
        return duration;
    }
    
    function getOwner () public view returns (address) {
        return owner;
    }
    
    function getNFT () public view returns (IERC721) {
        return nft;
    }
    
    function getNftID () public view returns (uint256) {
        return nftID;
    }
    
    function getHighestBid () public view returns (uint256) {
        return highestBid;
    }
    
}

