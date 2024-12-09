pragma solidity 0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

/**
 * @title
 * @author
 * @notice a very basic contract inherinting ERC721 and representing a booter of NFT won on the lucky dip bid.
 * Winner is the owner of all of the booster NFT/
 * The limit of mintable NFT is the number of NFT described in the former lucky dip.
 * @dev
 */
contract NFTBooster is ERC721, Ownable {
    error NFTBooster__TokenUriNotFound();
    error NFTBooster__MaxNbOfMintableNFTReached();

    mapping(uint256 tokenId => string tokenUri) private s_tokenIdToUri;
    uint256 private s_tokenCounter;
    uint256 private s_maxNumberOfMintableNFT;
    string s_description;
    uint256 s_finalBid;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _description,
        uint256 _finalBid,
        uint256 _maxNumberOfMintableNFT
    ) ERC721(_name, _symbol) {
        s_tokenCounter = 0;
        s_maxNumberOfMintableNFT = _maxNumberOfMintableNFT;
        s_description = _description;
        s_finalBid = _finalBid;
    }

    function mintNft(string memory tokenUri, address owner) public onlyOwner {
        if (s_maxNumberOfMintableNFT == s_tokenCounter + 1) {
            revert NFTBooster__MaxNbOfMintableNFTReached();
        }
        s_tokenIdToUri[s_tokenCounter] = tokenUri;
        _safeMint(owner, s_tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert NFTBooster__TokenUriNotFound();
        }
        string memory imageURI = s_tokenIdToUri[tokenId];

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                        abi.encodePacked(
                            '{"name":"', name(), '", "description":"', s_description, '", "image":"', imageURI, '"}'
                        )
                    )
                )
            )
        );
    }

    function getImageUri(uint256 tokenId) public view returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    function getTokenOwner(uint256 tokenId) public view returns (address) {
        return ownerOf(tokenId);
    }

    function getDescription() public view returns (string memory) {
        return s_description;
    }

    function getFinalBid() public view returns (uint256) {
        return s_finalBid;
    }
}
