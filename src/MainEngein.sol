// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {ModelNFTs} from "./NFT.sol";

contract ModelManager {
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

    mapping(address => user) private addressToUser;

    //Models
    mapping(address => mapping(string => address)) private userModelAdd; // manufacturer to mapp od modelno. to  contract add
    mapping(address => modelStruct[]) public usersToModel;

    function isManufacturer(address _add) public view returns (bool) {
        return (addressToUser[_add].IfManufacturer);
    }

    function createUser(bool _IfManufacturer, string memory _UserCid) public {
        addressToUser[msg.sender] = user(_UserCid, _IfManufacturer);
    }

    function addModel(
        string memory _modelName,
        string memory _modelNum
    ) public ONLY_MANUFACTURER {
        ModelNFTs model = new ModelNFTs(_modelName, _modelNum);
        userModelAdd[msg.sender][_modelNum] = address(model);
        usersToModel[msg.sender].push(
            modelStruct(address(model), _modelName, _modelNum)
        );
    }

    function mintNFT(
        string memory _modelNum,
        string memory _tokenURI
    ) public ONLY_MANUFACTURER {
        require(
            userModelAdd[msg.sender][_modelNum] != address(0),
            "Model does not exist"
        );
        ModelNFTs modelNFT = ModelNFTs(userModelAdd[msg.sender][_modelNum]);
        modelNFT.mint(msg.sender, _tokenURI);
    }

    function batchMintNFTs(
        string memory _modelNum,
        uint256 _totalNum,
        string memory _tokenURI
    ) public ONLY_MANUFACTURER {
        require(
            userModelAdd[msg.sender][_modelNum] != address(0),
            "Model does not exist"
        );
        ModelNFTs modelNFT = ModelNFTs(userModelAdd[msg.sender][_modelNum]);
        modelNFT.batchMint(msg.sender, _totalNum, _tokenURI);
    }

    function transferNFT(
        string memory _modelNum,
        address _from,
        address _to,
        uint256 _tokenId
    ) public ONLY_MANUFACTURER {
        require(
            userModelAdd[msg.sender][_modelNum] != address(0),
            "Model does not exist"
        );
        ModelNFTs modelNFT = ModelNFTs(userModelAdd[msg.sender][_modelNum]);
        modelNFT.transferNFT(_from, _to, _tokenId);
    }

    function batchTransferNFTs(
        string memory _modelNum,
        address _from,
        address _to,
        uint256[] memory _tokenIds
    ) public ONLY_MANUFACTURER {
        require(
            userModelAdd[msg.sender][_modelNum] != address(0),
            "Model does not exist"
        );
        ModelNFTs modelNFT = ModelNFTs(userModelAdd[msg.sender][_modelNum]);
        modelNFT.batchTransferNFTs(_from, _to, _tokenIds);
    }

    function getUser() public view returns(user memory){
        return(addressToUser[msg.sender]);
    }

    function getManufacturerModles() public view ONLY_MANUFACTURER returns(modelStruct[] memory){
        return(usersToModel[msg.sender]);
    }

    function getModlesTotalInventory(string memory _modelNum) public view ONLY_MANUFACTURER returns(uint256){
        ModelNFTs modelNFT = ModelNFTs(userModelAdd[msg.sender][_modelNum]);
        return(modelNFT.getTotalSupply());
    }

    function getTotalModelOwned(string memory _modelNum) public view returns(uint256[] memory){
        ModelNFTs modelNFT = ModelNFTs(userModelAdd[msg.sender][_modelNum]);
        return(modelNFT.getOwnersTokens());
    }
    //3rd party ownership visiblity.. 
    //
}
