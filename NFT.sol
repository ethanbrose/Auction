// SPDX-License-Identifier: GPL-3.0


pragma solidity >= 0.8.9;

contract NFT {
    
    address owner;
    
    function changeOwner () {
        
        owner = msg.sender;
        
    }
    
}