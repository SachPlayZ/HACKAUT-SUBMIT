// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract CertificateMinter is ERC721URIStorage {
    uint256 public tokenCounter;

    // Mapping to store the image URI for each token
    mapping(uint256 => string) private _tokenImageURIs;
    // Mapping to track certificates owned by each address
    mapping(address => uint256[]) private _ownedCertificates;

    event CertificateMinted(
        address indexed owner,
        uint256 indexed tokenId,
        string imageURI
    );

    constructor() ERC721("Certificate", "CERT") {
        tokenCounter = 0;
    }

    /// @dev Allows users to mint their own certificate NFT
    /// @param imageURI The IPFS URI pointing to the certificate image
    function mintCertificate(string memory imageURI) external {
        uint256 newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, imageURI);

        // Store the image URI
        _tokenImageURIs[newTokenId] = imageURI;

        // Track the certificates owned by the user
        _ownedCertificates[msg.sender].push(newTokenId);

        emit CertificateMinted(msg.sender, newTokenId, imageURI);

        tokenCounter++;
    }

    /// @dev Returns all image URIs for certificates owned by a specific address
    /// @param owner The address to query
    /// @return List of image URIs owned by the address
    function getOwnedCertificates(
        address owner
    ) external view returns (string[] memory) {
        uint256[] memory tokenIds = _ownedCertificates[owner];
        string[] memory imageURIs = new string[](tokenIds.length);

        for (uint256 i = 0; i < tokenIds.length; i++) {
            imageURIs[i] = _tokenImageURIs[tokenIds[i]];
        }

        return imageURIs;
    }
}