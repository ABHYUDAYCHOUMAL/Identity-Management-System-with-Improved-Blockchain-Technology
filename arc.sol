//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract ARC{
    struct token{
        string name;
        string value;
        address creator;
        bytes32 hash;
        bool exisit;
        bool claimed;
    }
    address owner;
    mapping(bytes32 => token) tokens;
    event LogTokenCreate(bytes32, string, string, address, bytes32);
    event LogTokenRevocation(bytes32);
    
    function tokenCreate(string memory  _name, string memory _value, bytes32  _hash)public returns (bytes32) {
        //bytes32 tokenId = sha256(abi.encodePacked(_name,_value,msg.sender,_hash,now));
        bytes32 tokenId = sha256(abi.encodePacked(_name,_value,_hash,_name));
        tokens[tokenId].name = _name;
        tokens[tokenId].value = _value;
        tokens[tokenId].creator = msg.sender;
        tokens[tokenId].hash = _hash;
        tokens[tokenId].exisit = true;
        tokens[tokenId].claimed = false;
        emit LogTokenCreate(tokenId, _name, _value, msg.sender, _hash);
        return tokenId;
    }
    function tokenRevocation(bytes32 _tokenId)public {
        address creator = creatorQuery(_tokenId);
        if (msg.sender == creator){
            revocation(_tokenId);
            emit LogTokenRevocation(_tokenId);
        }
    }
    function changeStatus(bytes32 _tokenId)public {
        tokens[_tokenId].claimed = true;
    }
    function revocation(bytes32 _tokenId)public {
        tokens[_tokenId].exisit = false;
    }
    function creatorQuery(bytes32 _tokenId)public view returns(address){
        address creator = tokens[_tokenId].creator;
        return creator;
    }
    function exisitQuery(bytes32 _tokenId)public view returns(bool){
        bool exisit = tokens[_tokenId].exisit;
        return exisit;
    }
    function claimedQuery(bytes32 _tokenId)public view returns(bool){
        bool claimed = tokens[_tokenId].claimed;
        return claimed;
    }    
    function tokenQuery(bytes32 _tokenId)public view returns(bytes32, string memory, string memory, bytes32, address, bool, bool){
        string memory name = tokens[_tokenId].name;
        string memory value = tokens[_tokenId].value;
        bytes32 hash = tokens[_tokenId].hash;
        address creator = tokens[_tokenId].creator;
        bool exisit = tokens[_tokenId].exisit;
        bool claimed = tokens[_tokenId].claimed;
        return (_tokenId, name, value, hash, creator, exisit, claimed);
    }
}