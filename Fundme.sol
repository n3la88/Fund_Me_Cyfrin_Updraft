// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "/PriceConverter.sol";

contract FundMe {

    using PriceConverter for uint256;

    uint256 public minUSD = 5 * 1e10; // or  uint256 public minUSD = 5e10

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable{
        //allow users to send $5
        //have a minimum $ to send
        
        require(msg.value.getConversionRate() >= minUSD, "Did not send enough ETH"); // 1e18 = 1 ETH = 1000000000000000000 = 1 *10 ** 18
        // 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

  


}