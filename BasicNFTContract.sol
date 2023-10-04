// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



contract SimpleNftContract is ERC721, Ownable {
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maxSupply;
    bool public isPublicMintEnabled;

    mapping(address => uint256) public mintedWallets;


    event Minted (address indexed _mintedWalletAddress, uint256 indexed _tokenId);


    constructor () ERC721("SimpleNftContract", "SNC") {
        mintPrice = 0.01 ether;
        totalSupply = 0;
        maxSupply = 10;
    }
    
    // Toggle isPublicMintEnabled
    function toggleIsPublicMintEnabled () external onlyOwner {
        isPublicMintEnabled = !isPublicMintEnabled;
    }

    // Change MaxSupply
    function changeMaxSupply (uint256 _newMaxSupply) external onlyOwner {
        maxSupply = _newMaxSupply;
    }
    
    // Mint
    function mint () public payable {
        require(isPublicMintEnabled, "public mint is not enabled");
        require(msg.value == mintPrice, "not enough funds");
        require(totalSupply < maxSupply, "sold out");
        require(mintedWallets[msg.sender] < 1, "exceeded max per wallet");
        
        mintedWallets[msg.sender] += 1;

        totalSupply += 1;
        uint256 newTokenId = totalSupply;
        _safeMint(msg.sender, newTokenId);
        
        emit Minted(msg.sender, newTokenId);
    }
}