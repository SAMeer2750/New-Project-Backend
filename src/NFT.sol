// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ModelNFTs is ERC721{

    constructor(string memory _ModelName, string memory _ModelNum) ERC721(_ModelName, _ModelNum){}

    uint256 tokenId;

    function mint(address _to) external {
        _safeMint(_to, tokenId);
        tokenId ++;
    }

    function batchMint(address _to, uint256 _totalNum) external {
        for (uint256 i = 0; i < _totalNum; i++) {
            _safeMint(_to, tokenId);
            tokenId ++;
        }
    }

    function transferNFT(address _from, address _to, uint256 _tokenId) external{
        _transfer(_from, _to, _tokenId);
    }

    function batchTransferNFTs(address _from, address _to, uint256[] memory _tokenIds) external {
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            uint256 tokenIdToTransfer = _tokenIds[i];
            _transfer(_from, _to, tokenIdToTransfer);
        }
    }

    function getNextTokenId() external view returns (uint256) {
        return tokenId;
    }

    function getTotalSupply() external view returns(uint256){
        return tokenId-1;
    }

}

