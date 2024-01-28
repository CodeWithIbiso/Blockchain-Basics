{/**
    Get funds from users
    Withdraw funds
    Set a minimum funding value in USD
*/}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";


error NotOwner()
contract FundMe{ 
    using PriceConverter for uint256; // this way we've attached price converter to uint256 as a property

    uint256 MINIMUM_USD = 50 * 1e18;
    address funders[];
    // mapping is like objects - key value pairs
    mapping(address=>uint256) public addressToAmountFunded;

    address public immutable i_owner;
    constructor{
        i_owner = msg.sender;
    }

    // constant and immutable - if a variable is constant it doesnt take up storage spot saving gas

    function fund()public payable{ // payable will make the color red
        // Contracts can hold funds just like how wallets can

        require(msg.value.getConversionRate() >= MINIMUM_USD,"The minimum required token to be sent is 1. Please input atleast 1 Eth and try again."); // We want to be able to send a minimum fund amount (1e18 = 1 * 10 ** 18 as it accepts units in wei)
        // gas are reverted if require failed.


        // oracles and chainlink comes in to help conversion from realfunds to tokens
        // we'll need a decentralized oracle network to get the price of one usd to Ether - this oracle network is chainlink https://data.chain.link https://docs.chain.link
        // oracle problem is that our deterministic decentralized network cannot connect to the outside

        /**
            chainlink keepers listen for events. Price changes and whatnot
            chainlink vrf is a way to get provable random numbers in a decentralized context
            chainlink nodes can make http request and u can use it to set up ur own chainlink network for getting data from chainlink nodes or data providers

            whenever we request data from a chainlink node we have to pay a link token or oracle gas - LINKS
        */
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    } 

    function withdraw() public onlyOwner { // before function executes - look at onlyOwner if it passes
        //
        // reset the array
        funders = new address[](0) // setting the funders array to 0


        // actually withdraw the funds - transfer,send or call
        /**
            msg.sender is an address so to pay to it we have to typecast to a payable address
         */
        // // transfer
        //  payable(msg.sender).transfer(address(this).balance) // if failed will throw error and revert - capped gas is 2300
        // // send
        //  bool sendSuccess = payable(msg.sender).send(address(this).balance) // if failed will return boolean
        //  require(sendSuccess,"Send Failed"); // and only revert when we add this line - capped gas is 2300
        //  call - the recommended way
         (bool callSuccess, bytes memory dataReturned ) = payable(msg.sender).call{value : address(this).balance}("") // call returns 2 variables - no capped gas


    }

    modifier onlyOwner{
        // require(msg.sender == i_owner,"Sender is not owner");
        if(msg.sender != i_owner) { revert NotOwner()}; // this will save gas than that code above and also revert() can be called in any function
        _; // do whats in the function this modifier was called on - if this was before the require then the code will run first before the require
    }


    // receive and fallback - how to handle money being sent to contract without using the fundMe function

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

}














