pragma solidity >= 0.8.9;

contract WinAuction {
    
    event Win(address winner, uint256 amount);

    IERC721 public nft;
    uint public nftId;

    address payable public seller;
    address public winner;

    constructor(
        address _nft,
        uint _nftId
    ) {
        seller = payable(msg.sender);
        nft = IERC721(_nft);
        nftId = _nftId;
    }

    // Winds the auction for the specified amount
    function win() external payable {
        winner = msg.sender;
        nft.safeTransferFrom(seller, msg.sender, nftId);
        seller.transfer(msg.value);

        emit Win(msg.sender, msg.value);
    }
}