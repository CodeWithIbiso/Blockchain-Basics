// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract SimpleStorage{
    uint256 favoriteNumber;

    // mapping
    mapping(string=>uint256) public nameToFavoriteNumber;

    struct People{
        uint256 favoriteNumber;
        string name;
    }

    People[] public people;

    function store(uint256 _favoriteNumber)public virtual{ // virtual is to identify that this function can be overridden - check ExtraStorage
        favoriteNumber = _favoriteNumber;
    }

    // view, pure
    function retrieve()public view returns(uint256){
        return favoriteNumber;
    }

    // calldata, memory, storage
    function addPerson(string memory _name, uint256 _favoriteNumber)public{
        people.push(People(_favoriteNumber,_name));

        // with mappings 
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}