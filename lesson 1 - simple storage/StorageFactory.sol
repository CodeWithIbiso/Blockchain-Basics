// SPDX-License-Identifier: MIT
pragma solidity ^0.88;

import "./simpleStorage.sol";

contract StorageFactory{ 

    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract()public{
        SimpleStorage simpleStorage = new SimpleStorage(); // this is how solidity knows we are going to deploy a new contract
        simpleStorageArray.push(simpleStorage);
    }
 
    // storage factory store
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber)public{
        // Address
        // ABI - Application Binary Interface
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        simpleStorage.store(_simpleStorageNumber); // updates that index with the number received
    }


    function sfGet(uint256 _simpleStorageIndex)public view returns(uint256){
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        return simpleStorage.retrieve(); // gets the properties (eg number stored) in this particular simple storage index

        // you can still just do 
        // return SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex].retrieve()
    }
}