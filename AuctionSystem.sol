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
    string public description;
    
    uint256 public highestBid = 0;
    address public highestBidder = address(0);
    
    
    //The constructor initializes many variables. I guess it is OG design to choose the auction duration. There are a lot of choices of to make about the duration now.
    constructor (uint256 numDays, uint256 startingPrice) {
        require (startingPrice > 0 && numDays >= 0, "Error: Invalid parameter(s). Price must be greater than 0 and time intervals can be specified as 0 or greater.");
        highestBid = startingPrice;
        owner = payable (msg.sender);
        //duration = block.timestamp + (numWeeks * 1 weeks);
        duration = block.timestamp + (numDays * 1 days);
        //duration = block.timestamp + (numHours * 1 hours);
        //duration = block.timestamp + (numMins * 1 minutes);
    }
    
    
    
    //regular old bid function. IMPLEMENTS OG DESIGN: adding 10 mins when a bid is placed AND the 20% higher than current price confirmation. Solved by just having two methods to bid.
    function bid (uint256 curBid) public notEnded {
        require ((highestBid + (highestBid/5)) > curBid, "Quite the large bid there. If you are sure about bidding more than 20% higher than the current highest price, please use the bidBigger method.");
        require (curBid > highestBid, "Error: your bid is not smaller than the current highest!");
        highestBid = curBid;
        highestBidder = msg.sender;
        duration += (1 * 10 minutes);
    }
    
    function bidBigger (uint256 curBid) public notEnded {
        require (curBid > highestBid, "Error: your bid is not smaller than the current highest!");
        highestBid = curBid;
        highestBidder = msg.sender;
        duration += (1 * 10 minutes);
    }
    
    
    //OG DESIGN METHOD: if called, this function automatically bids a bid 5% larger than the current highest bid.
    function quickBid () public notEnded {
            highestBid = highestBid + (highestBid/20);
            highestBidder = msg.sender;
            duration += (1 * 10 minutes);
    }
    
    event Win (address _highestBidder, uint256 _highestBid);
    
    function winAuction () public payable ended {
        
        require (highestBidder != address(0), "Nobody has bid. You still have ownership of your NFT.");
        
        nft.safeTransferFrom (address(this), highestBidder, nftID);
        
        emit Win (highestBidder, highestBid);
        
    }
    
    function winNow () public payable {
        nft.safeTransferFrom (address(this), highestBidder, nftID);
        
        emit Win (highestBidder, highestBid);
    }
    
    //OG DESIGN FEATURE
    function pullAuction () public {
        require (msg.sender == owner, "Error: You may not do that.");
        delete nft;
        delete nftID;
        setDuration (0);
        setHighestBidder(address(0));
    }
    
    
    //modifier section
    
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
    
    function getCurrentTimestamp () public view returns (uint256) {
        return block.timestamp;
    }
    
    // setter section
    
    function setDuration (uint256 numDays) public {
        //duration = block.timestamp + (numWeeks * 1 weeks);
        duration = (numDays * 1 days);
        //duration = block.timestamp + (numHours * 1 hours);
        //duration = block.timestamp + (numMins * 1 minutes);
    }
    
    function setHighestBidder (address _highestBidder) public {
        highestBidder = _highestBidder;
    }
    
    function setDescription (string memory _description) public {
        require (bytes(_description).length <= 151 && bytes(_description).length > 0, "Error: Description must be within 0-150 characters!");
        description = _description;
    }
    
    function setNFT (IERC721 _nft, uint256 _nftID) public {
        nft = _nft;
        nftID = _nftID;
    }
    
}

