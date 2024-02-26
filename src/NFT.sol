// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract ModelNFTs is ERC721URIStorage{

    address immutable i_shoyu;
    uint256 private tokenId;

    modifier ONLY_SHOYU (){
        require(msg.sender == i_shoyu);
        _;
    }

    constructor(string memory _ModelName, string memory _ModelNum , address _shoyu) ERC721(_ModelName, _ModelNum) {
        i_shoyu = _shoyu;
        tokenId = 1;
    }

    mapping (address => uint256[]) private addressToTokenIds ;

    function mint(address _to, string memory _tokenURI) external ONLY_SHOYU{
        _safeMint(_to, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        addressToTokenIds[_to].push(tokenId);
        tokenId ++;
    }

    function batchMint(address _to, uint256 _totalNum, string memory _tokenURI) external ONLY_SHOYU{
        for (uint256 i = 0; i < _totalNum; i++) {
            _safeMint(_to, tokenId);
            _setTokenURI(tokenId, _tokenURI);
            addressToTokenIds[_to].push(tokenId);
            tokenId ++;
        }
    }

    function transferNFT(address _from, address _to, uint256 _tokenId) public{
        _transfer(_from, _to, _tokenId);
        for (uint256 i = 0; i < addressToTokenIds[_from].length; i++) {
            if (addressToTokenIds[_from][i] == _tokenId) {
                addressToTokenIds[_from][i] = addressToTokenIds[_from][addressToTokenIds[_from].length - 1];
                addressToTokenIds[_from].pop();
                break;
            }
        }
        addressToTokenIds[_to].push(_tokenId);
    }

    function batchTransferNFTs(address _from, address _to, uint256[] memory _tokenIds) external {
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            uint256 tokenIdToTransfer = _tokenIds[i];
            transferNFT(_from, _to, tokenIdToTransfer);
        }
    }

    function getNextTokenId() external view returns (uint256) {
        return tokenId;
    }

    function getTotalSupply() external view returns(uint256){
        return tokenId-1;
    }

    function getOwnersTokens() external view returns(uint256 [] memory){
        return addressToTokenIds[msg.sender];
    }

}

