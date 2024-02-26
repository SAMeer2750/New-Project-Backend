// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {ModelNFTs} from "./NFT.sol";

contract Shoyu {
    modifier ONLY_MANUFACTURER() {
        require(addressToUser[msg.sender].IfManufacturer);
        _;
    }

    //user
    struct user {
        string UserCid;
        bool IfManufacturer;
    }

    struct modelStruct {
        address contractAdd;
        string modelName;
        string modelNum;
    }

    struct listedToken {
        address contractAdd;
        uint256 tokenId;
        bool offer;
    }

    mapping(address => user) private addressToUser;

    mapping(address => mapping(string => address))
        private manuToModelNoToModelAdd; // manufacturer to mapp od modelno. to  contract add
    mapping(address => modelStruct[]) private manuToModel;

    // listedToken[] private listedTokens;
    // mapping(address => listedToken[]) private myListedTokens;

    function isManufacturer(address _add) external view returns (bool) {
        return (addressToUser[_add].IfManufacturer);
    }

    function createUser(bool _IfManufacturer, string memory _UserCid) external {
        addressToUser[msg.sender] = user(_UserCid, _IfManufacturer);
    }

    function addModel(
        string memory _modelName,
        string memory _modelNum
    ) external ONLY_MANUFACTURER {
        ModelNFTs model = new ModelNFTs(_modelName, _modelNum, address(this));
        manuToModelNoToModelAdd[msg.sender][_modelNum] = address(model);
        manuToModel[msg.sender].push(
            modelStruct(address(model), _modelName, _modelNum)
        );
    }

    function mintNFT(
        string memory _modelNum,
        string memory _tokenURI
    ) external ONLY_MANUFACTURER {
        require(
            manuToModelNoToModelAdd[msg.sender][_modelNum] != address(0),
            "Model does not exist"
        );
        ModelNFTs modelNFT = ModelNFTs(
            manuToModelNoToModelAdd[msg.sender][_modelNum]
        );
        modelNFT.mint(msg.sender, _tokenURI);
    }

    function batchMintNFTs(
        string memory _modelNum,
        uint256 _totalNum,
        string memory _tokenURI
    ) external ONLY_MANUFACTURER {
        require(
            manuToModelNoToModelAdd[msg.sender][_modelNum] != address(0),
            "Model does not exist"
        );
        ModelNFTs modelNFT = ModelNFTs(
            manuToModelNoToModelAdd[msg.sender][_modelNum]
        );
        modelNFT.batchMint(msg.sender, _totalNum, _tokenURI);
    }

    function transferNFT(
        string memory _modelNum,
        address _from,
        address _to,
        uint256 _tokenId
    ) external {
        require(
            manuToModelNoToModelAdd[msg.sender][_modelNum] != address(0),
            "Model does not exist"
        );
        ModelNFTs modelNFT = ModelNFTs(
            manuToModelNoToModelAdd[msg.sender][_modelNum]
        );
        modelNFT.transferNFT(_from, _to, _tokenId);
    }

    function batchTransferNFTs(
        string memory _modelNum,
        address _from,
        address _to,
        uint256[] memory _tokenIds
    ) external {
        require(
            manuToModelNoToModelAdd[msg.sender][_modelNum] != address(0),
            "Model does not exist"
        );
        ModelNFTs modelNFT = ModelNFTs(
            manuToModelNoToModelAdd[msg.sender][_modelNum]
        );
        modelNFT.batchTransferNFTs(_from, _to, _tokenIds);
    }

    // function normalListing(
    //     uint256 _amt,
    //     uint256 _tokenId,
    //     address _contract
    // ) external {
    //     myListedTokens[msg.sender].push(
    //         listedToken(_contract, _tokenId, false)
    //     );
    //     listedTokens.push(
    //         listedToken(_contract, _tokenId, false));
        
    // }

    // function oferListing(uint256 _tokenId, address _contract) external {
    //     myListedTokens[msg.sender].push(
    //         listedToken(_contract, _tokenId, true));
    //     listedTokens.push(
    //         listedToken(_contract, _tokenId, true));
    // }

    function getUser() external view returns (user memory) {
        return (addressToUser[msg.sender]);
    }

    function getManufacturerModles()
        external
        view
        ONLY_MANUFACTURER
        returns (modelStruct[] memory)
    {
        return (manuToModel[msg.sender]);
    }

    function getModlesTotalInventory(
        string memory _modelNum
    ) external view ONLY_MANUFACTURER returns (uint256) {
        ModelNFTs modelNFT = ModelNFTs(
            manuToModelNoToModelAdd[msg.sender][_modelNum]
        );
        return (modelNFT.getTotalSupply());
    }

    function getTotalModelOwned(
        string memory _modelNum
    ) external view returns (uint256[] memory) {
        ModelNFTs modelNFT = ModelNFTs(
            manuToModelNoToModelAdd[msg.sender][_modelNum]
        );
        return (modelNFT.getOwnersTokens());
    }
    //3rd party ownership visiblity..
    //all listing
    //auctions..
}
