// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// contract PatientList is Ownable, ERC721 {
    
//     string[] public patDets;
//     string[] public patHist;
//     string[] public patMom;
//     string[] public patDad;
    
//     string private _baseURIextended;
//     uint256 public _tokenIds;
//     using Strings for uint256;
//     mapping(uint256 => string) private _tokenURIs;

//     event PatientCreated(string[] patientDetails, string[] patientHistory, string[] patientMother, string[] patientFather);

//     function setBaseURI(string memory baseURI_) public {
//         _baseURIextended = baseURI_;
//     }

//     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
//         internal
//         virtual
//     {
//         require(
//             _exists(tokenId),
//             "ERC721Metadata: URI set of nonexistent token"
//         );
//         _tokenURIs[tokenId] = _tokenURI;
//     }

//     function _baseURI() internal view virtual override returns (string memory) {
//         return _baseURIextended;
//     }

//     function tokenURI(uint256 tokenId)
//         public
//         view
//         virtual
//         override
//         returns (string memory)
//     {
//         require(
//             _exists(tokenId),
//             "ERC721Metadata: URI query for nonexistent token"
//         );

//         string memory _tokenURI = _tokenURIs[tokenId];
//         string memory base = _baseURI();

//         // If there is no base URI, return the token URI.
//         if (bytes(base).length == 0) {
//             return _tokenURI;
//         }
//         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
//         if (bytes(_tokenURI).length > 0) {
//             return string(abi.encodePacked(base, _tokenURI));
//         }
//         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
//         return string(abi.encodePacked(base, tokenId.toString()));
//     }

//     constructor() ERC721("patientList", "PATLIST") {}

//     function createPatient(string memory _uid, string memory _patientName, string memory _patientAge, string memory _patientBirthCountry, string memory _patientSex, string[] memory _patientHistory, string memory tokenURI) public returns (uint256){
       
//         patDets.push(_uid);
//         patDets.push(_patientName);
//         patDets.push(_patientAge);
//         patDets.push(_patientBirthCountry);
//         patDets.push(_patientSex);
//         for(uint256 i=0; i<=_patientHistory.length; i = i+1){
//             patHist.push(_patientHistory[i]);
//         }
//         emit PatientCreated(patDets, patHist, patMom, patDad);
//         uint256 newItemId = _tokenIds;
//         _safeMint(msg.sender, newItemId);
//         _setTokenURI(newItemId, tokenURI);
//         return newItemId;
//     }
    
// }
contract PatientList is Ownable, ERC721 {

    struct Patient{
        string uid;
        string patientName;
        string patientInfo;
        string patientDets;
    }

    mapping(uint => Patient) public patients;

    uint256 public _tokenIds;
    using Strings for uint256;
    mapping(uint256 => string) private _tokenURIs;

    string private _baseURIextended;

    event PatientCreated(string uid, string patName, string patInfo, string patDet);

    constructor() ERC721("patientList", "PATLIST") {    
        //patients[0] = Patient("39aHr2VNiDPuFpqgXFm81uQbzN23", "Ritika Desai", "23", "India", "Female", "History");
    }

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

    function createPatient(string memory _uid, string memory _patientName, string memory _patientInfo, string memory _patientDets, string memory tokenURI) public returns (uint256){
       
        patients[_tokenIds++] = Patient(_uid, _patientName, _patientInfo, _patientDets);
        emit PatientCreated(_uid, _patientName, _patientInfo, _patientDets);
        uint256 newItemId = _tokenIds;
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }
}
