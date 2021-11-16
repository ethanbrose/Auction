pragma solidity 0.8.9;

contract Bidder {
    
    uint256 curBid;
    
    
    function quickBid () {
        curBid = curBid * 1.05;
    }
    
    
}