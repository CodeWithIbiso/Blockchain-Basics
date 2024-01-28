// SPDX-License-Identifier: MIT
pragma solidity ^0.88;

import "./simpleStorage.sol";


// inherit from simpleStorage to be a child of simpleStorage
contract ExtraStorage is SimpleStorage{ 

    function store(uint256 _favoriteNumber)public override{ // override is to identify that this function overrides another - check SimpleStorage
        favoriteNumber = _favoriteNumber + 5;
    }
}