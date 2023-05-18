//SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


// Certificate is an ERC721 non-fungible token that represents a certificate.
contract Certificate is ERC721URIStorage {
    // Event that is emitted when a certificate is created.
    event CertificateCreated(
        address indexed sender,
        address indexed receiver,
        string imageUrl,
        uint256 tokenId
    );

    // Counters to keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Mapping from user address to the array of certificates they have created.
    mapping (address => uint256[]) public createdCertificates;
    // Mapping from user address to the array of certificates they have received.
    mapping (address => uint256[]) public receivedCertificates;
    // Mapping from certificate id to the issuer address.
    mapping (uint256 => address) public certificateIssuers;

    // Mapping from address to a boolean value indicating whether the address is an issuer.
    mapping (address => bool) public isIssuer;
    // Mapping from address to the number of votes they have received.
    mapping (address => uint) public voteCount;
    // Number of issuers.
    uint public numIssuers;

    // Constructor that sets the contract owner to the msg.sender.
    constructor() ERC721("Certificate", "CERT") {
        // Set the contract owner to the msg.sender.
        _mint(msg.sender, 0);
        // Add the contract owner as the first issuer.
        isIssuer[msg.sender] = true;
        // Increment the number of issuers.
        numIssuers++;
    }

    // Function that allows any user to create a certificate for another user.
    function createCertificate(address _receiver, string memory _imageUrl) public {
        // Validate that the sender is an issuer.
        require(isIssuer[msg.sender], "Sender is not an issuer");

        // Validate that the receiver is not the zero address.
        require(_receiver != address(0), "Receiver is the zero address");

        // Create the certificate and mint it to the receiver.
        uint256 newItemId = _tokenIds.current() + 1;
        _mint(_receiver, newItemId);
        _setTokenURI(newItemId, _imageUrl);

        _tokenIds.increment();

        // Add the certificate to the created and received certificate lists.
        createdCertificates[msg.sender].push(newItemId);
        receivedCertificates[_receiver].push(newItemId);

        // Map certificate id to issuer address
        certificateIssuers[newItemId] = msg.sender;

        // Emit the CertificateCreated event.
        emit CertificateCreated(msg.sender, _receiver, _imageUrl, newItemId);
    }

    // Function that returns the array of certificates created by a user.
    function getCreatedCertificates(address _user) public view returns (uint256[] memory) {
        return createdCertificates[_user];
    }

    // Function that returns the array of certificates received by a user.
    function getReceivedCertificates(address _user) public view returns (uint256[] memory) {
        return receivedCertificates[_user];
    }

    // Function that returns the issuer of certificate received by a user.
    function getCertificateIssuer(uint256 _tokenId) public view returns (address) {
        return certificateIssuers[_tokenId];
    }

    // Function that adds a new issuer if the sender is already an issuer and
    // there are fewer than 5 issuers, or if more than 50% of existing issuers
    // have voted to add the new issuer.
    function addIssuer(address _newIssuer) public {
        // Validate that the sender is an issuer.
        require(isIssuer[msg.sender], "Sender is not an issuer");

        // Validate that the new issuer is not already an issuer.
        require(!isIssuer[_newIssuer], "New issuer is already an issuer");

        // If there are fewer than 5 issuers, the sender can add the new issuer.
        if (numIssuers < 5) {
            isIssuer[_newIssuer] = true;
            numIssuers++;
            return;
        }

        // Otherwise, more than 50% of existing issuers must vote to add the new issuer.
        voteCount[_newIssuer]++;

        // Calculate the percentage of votes the new issuer has received.
        uint votePercentage = voteCount[_newIssuer] * 100 / numIssuers;

        // If the new issuer has received more than 50% of the votes, add them as an issuer.
        if (votePercentage > 50) {
            isIssuer[_newIssuer] = true;
            numIssuers++;
        }
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public pure override{
        revert("Certificates can't be transferred");
    }

    function transferFrom(address from, address to, uint256 tokenId) public pure override{
        revert("Certificates can't be transferred");
    }
}