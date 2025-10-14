// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft_CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUrl;
    string private s_happySvgImageUrl;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdtoMood;

    constructor(string memory sadSvgImageUri, string memory happySvgImageUri) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageUrl = sadSvgImageUri;
        s_happySvgImageUrl = happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdtoMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        _checkAuthorized(owner, msg.sender, tokenId);
        if (s_tokenIdtoMood[tokenId] == Mood.HAPPY) {
            s_tokenIdtoMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdtoMood[tokenId] = Mood.HAPPY;
        }
    }

    // function flipMood1(uint256 tokenId) public {
    //     if (
    //         _getApproved(tokenId) != msg.sender &&
    //         ownerOf(tokenId) != msg.sender
    //     ) {
    //         revert MoodNft_CantFlipMoodIfNotOwner();
    //     }

    //     if (s_tokenIdtoMood[tokenId] == Mood.HAPPY) {
    //         s_tokenIdtoMood[tokenId] = Mood.SAD;
    //     } else {
    //         s_tokenIdtoMood[tokenId] = Mood.HAPPY;
    //     }
    // }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdtoMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUrl;
        } else {
            imageURI = s_sadSvgImageUrl;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "An NFT that reflects your mood!", "attributes": [{"trait_type": "Mood", "value": 100}], "image": "',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
