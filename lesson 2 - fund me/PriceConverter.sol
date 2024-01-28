// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

// this will be a library that we will attach to 
// libraries cant have state variables, cant send ether and all the functions are internal

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter{ 

    function getPrice() internal  {
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

    function getConversionRate(uint256 ethAmount) internal  view returns (uint256){
        // in solidity maths always multiply before you divide
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) /  1e18;

        return ethAmountInUsd;
    }
}