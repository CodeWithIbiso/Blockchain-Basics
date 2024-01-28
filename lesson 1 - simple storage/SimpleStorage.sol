// SPDX-License-Identifier: MIT
pragma solidity ^0.88;

contract SimpleStorage{
    uint256 favoriteNumber;

    // mapping
    mapping(string=>unint256) public nameToFavoriteNumber;

    struct People{
        unint256 favoriteNumber;
        string name;
    }

    People[] public people;

    function store(uint256 _favoriteNumber)public virtual{ // virtual is to identify that this function can be overridden - check ExtraStorage
        favoriteNumber = _favoriteNumber
    }

    // view, pure
    function retrieve()public view returns(unint256){
        returns favoriteNumber
    }

    // calldata, memory, storage
    function addPerson(string memory _name, unint256 _favoriteNumber)public{
        people.push(People(_favoriteNumber,_name));

        // with mappings 
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}