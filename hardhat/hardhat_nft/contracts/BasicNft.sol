// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract BasicNft is ERC721URIStorage {
    string public constant TOKEN_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    uint256 private s_tokenCounter;

    // Events
    event NftMinted(uint256 indexed tokenId, string indexed tokenUri, address indexed minter);
    event NftBurnt(uint256 indexed tokenId, address indexed minter);

    constructor() ERC721("DemoNft", "DNFT") {
        s_tokenCounter = 0;
    }

    function mintNft() public returns (uint256) {
        uint256 newTokenId = s_tokenCounter;
        _safeMint(msg.sender, s_tokenCounter);
        _setTokenURI(newTokenId, TOKEN_URI);
        emit NftMinted(newTokenId, TOKEN_URI, msg.sender);
        s_tokenCounter = s_tokenCounter + 1;
        return s_tokenCounter; 
    } 

    function burnNft(uint256 _tokenId) public returns (uint256) {
        _burn(_tokenId);
        emit NftBurnt(_tokenId, msg.sender);
        s_tokenCounter = s_tokenCounter - 1;
        return s_tokenCounter; 
    } 

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}