// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint private s_tokenCounter;
    mapping(uint256 tokenId => string) private s_tokenIdtoUrl;

    constructor() ERC721("Dogie", "DOG") {
        s_tokenCounter = 0;
    }

    function mintNft(string memory tokenUri) public {
        s_tokenIdtoUrl[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter);

        s_tokenCounter++;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return s_tokenIdtoUrl[tokenId];
    }
}
