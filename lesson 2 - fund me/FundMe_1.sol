{/**
    Get funds from users
    Withdraw funds
    Set a minimum funding value in USD
*/}

// SPDX-License-Identifier: MIT
pragma solidity ^0.88;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe{ 

    uint256 minimumUsd = 50 * 1e18;
    address funders[];
    // mapping is like objects - key value pairs
    mapping(address=>uint256) public addressToAmountFunded;

    function fund()public payable{ // payable will make the color red
        // Contracts can hold funds just like how wallets can

        require(getConversionRate(msg.value) >= minimumUsd,"The minimum required token to be sent is 1. Please input atleast 1 Eth and try again."); // We want to be able to send a minimum fund amount (1e18 = 1 * 10 ** 18 as it accepts units in wei)
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

    function getPrice() public {
        // we will need chainlink data feeds to get the current price https://docs.chain.link/docs/ethereum-addresses
        // get ETH / USD address
        // get ABI
        // Address = 0x8A753474A1FA... github smartcontracts...
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753474A1FA..);
        (,int256 price,,,) = priceFeed.latestRoundData();
        // ETH in terms of USD
        // 3000.00000000 but it comes as 300000000000
        return uint256(price * 1e10); // 1 ** 10 =  10000000000
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        // in solidity maths always multiply before you divide
        uint256 ethPrice = getPrice()
        uint256 ethAmountInUsd = (ethPrice * ethAmount) /  1e18;

        return ethAmountInUsd;
    }


    function withdraw(){}
}