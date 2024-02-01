// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {ModelNFTs} from "./NFT.sol";

contract ModelManager {
    modifier ONLY_Manufacturer() {
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

    mapping(address => user) public addressToUser;

    //Models
    mapping(address => mapping(string => address)) public userModelAdd; // manufacturer to mapp od modelno. to  contract add
    mapping(address => modelStruct[]) public usersToModel;

    function isManufacturer(address _add) public view returns (bool) {
        return (addressToUser[_add].IfManufacturer);
    }

    function createUser(bool _IfManufacturer, string memory _UserCid) public {
        addressToUser[msg.sender] = user(_UserCid, _IfManufacturer);
    }

    function addModel(
        string memory _ModelName,
        string memory _ModelNum
    ) public ONLY_Manufacturer {
        ModelNFTs model = new ModelNFTs(_ModelName, _ModelNum);
        userModelAdd[msg.sender][_ModelNum] = address(model);
        usersToModel[msg.sender].push(
            modelStruct(address(model), _ModelName, _ModelNum)
        );
    }

    function mintNFT(
        string memory _ModelNum,
        string memory _tokenURI
    ) public ONLY_Manufacturer {
        require(
            userModelAdd[msg.sender][_ModelNum] != address(0),
            "Model does not exist"
        );
        ModelNFTs modelNFT = ModelNFTs(userModelAdd[msg.sender][_ModelNum]);
        modelNFT.mint(msg.sender, _tokenURI);
    }

    function batchMintNFTs(
        string memory _ModelNum,
        uint256 _totalNum,
        string memory _tokenURI
    ) public ONLY_Manufacturer {
        require(
            userModelAdd[msg.sender][_ModelNum] != address(0),
            "Model does not exist"
        );
        ModelNFTs modelNFT = ModelNFTs(userModelAdd[msg.sender][_ModelNum]);
        modelNFT.batchMint(msg.sender, _totalNum, _tokenURI);
    }

    function transferNFT(
        string memory _ModelNum,
        address _from,
        address _to,
        uint256 _tokenId
    ) public ONLY_Manufacturer {
        require(
            userModelAdd[msg.sender][_ModelNum] != address(0),
            "Model does not exist"
        );
        ModelNFTs modelNFT = ModelNFTs(userModelAdd[msg.sender][_ModelNum]);
        modelNFT.transferNFT(_from, _to, _tokenId);
    }

    function batchTransferNFTs(
        string memory _ModelNum,
        address _from,
        address _to,
        uint256[] memory _tokenIds
    ) public ONLY_Manufacturer {
        require(
            userModelAdd[msg.sender][_ModelNum] != address(0),
            "Model does not exist"
        );
        ModelNFTs modelNFT = ModelNFTs(userModelAdd[msg.sender][_ModelNum]);
        modelNFT.batchTransferNFTs(_from, _to, _tokenIds);
    }
}
