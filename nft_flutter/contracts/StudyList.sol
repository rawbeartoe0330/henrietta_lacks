// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StudyList is Ownable, ERC721 {

    struct Study{
        string researcherUID;
        string studyTitle;
        string patientUID1;
        string patientUID2;
        string patientUID3;
        string patientUID4;
        string patientUID5;
    }

    mapping(uint => Study) public studies;

    uint256 public _tokenIds;
    using Strings for uint256;
    mapping(uint256 => string) private _tokenURIs;

    string private _baseURIextended;

    event StudyCreated(string resUID, string title, string patUID1, string patUID2, string patUID3, string patUID4, string patUID5);

    constructor() ERC721("studyList", "STUDYLIST") {}

    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURIextended = baseURI_;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI)
        internal
        virtual
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI set of nonexistent token"
        );
        _tokenURIs[tokenId] = _tokenURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString()));
    }

    function createStudy(string memory _researcherUID, string memory _studyTitle,  string memory _patientUID1, string memory _patientUID2, string memory _patientUID3, string memory _patientUID4, string memory _patientUID5, string memory tokenURI) public returns (uint256){
       
        studies[_tokenIds++] = Study(_researcherUID, _studyTitle, _patientUID1, _patientUID2, _patientUID3, _patientUID4, _patientUID5);
        emit StudyCreated(_researcherUID, _studyTitle, _patientUID1, _patientUID2, _patientUID3, _patientUID4, _patientUID5);
        uint256 newItemId = _tokenIds;
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }
}