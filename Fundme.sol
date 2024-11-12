// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint256 public minUSD = 5 * 1e10; // or  uint256 public minUSD = 5e10

    function fund() public payable{
        //allow users to send $5
        //have a minimum $ to send

        require(getConversionRate(msg.value) >= minUSD, "Did not send enough ETH"); // 1e18 = 1 ETH = 1000000000000000000 = 1 *10 ** 18

    
    }

    function getPrice() public view returns(uint256) {
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        ( , int256 answer,  ,  ,  ) = priceFeed.latestRoundData();
        // Price of ETH in terms of USD
        // 2000.000000000
        return uint256(answer * 1e10);
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        // 1 ETH???
        // The answer = 2000_000000000000000000
        uint256 ethPrice = getPrice();
        // 2000_000000000000000000 * 1_000000000000000000 / 1e10;
        // $2000 = 1 ETH
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e10;
        return ethAmountInUSD;
    }



}