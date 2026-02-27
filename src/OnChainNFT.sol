// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract OnchainNFT is ERC721 {
    using Strings for uint256;

    uint256 private _id;

    constructor() ERC721("OnchainNFT", "OCNFT") {}

    function mint() external {
        _id++;
        _safeMint(msg.sender, _id);
    }

    function _svg(uint256 tokenId) internal pure returns (string memory) {
        // tiny “dynamic” example
        string memory color = (tokenId % 2 == 0) ? "black" : "purple";

        return string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' width='600' height='600'>",
                "<rect width='100%' height='100%' fill='", color, "'/>",
                "<text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' ",
                "fill='white' font-size='34' font-family='monospace'>",
                "On-chain #", tokenId.toString(),
                "</text></svg>"
            )
        );
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Not minted");

        string memory imageB64 = Base64.encode(bytes(_svg(tokenId)));

        bytes memory json = abi.encodePacked(
            "{",
                "\"name\":\"OnchainNFT #", tokenId.toString(), "\",",
                "\"description\":\"A fully on-chain NFT (SVG + metadata).\",",
                "\"image\":\"data:image/svg+xml;base64,", imageB64, "\"",
            "}"
        );

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(json)
            )
        );
    }
}