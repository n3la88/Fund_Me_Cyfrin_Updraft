// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "/PriceConverter.sol";

contract FundMe {

    using PriceConverter for uint256;

    uint256 public minUSD = 5 * 1e10; // or  uint256 public minUSD = 5e10

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public owner;

    //Function that is called inmediately 
    constructor() {
        owner = msg.sender;
    }

    function fund() public payable{
        //allow users to send $5
        //have a minimum $ to send
        
        require(msg.value.getConversionRate() >= minUSD, "Did not send enough ETH"); // 1e18 = 1 ETH = 1000000000000000000 = 1 *10 ** 18
        // 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function withdraw() public onlyOwner {
   
        // for loop(starting index, ending index, step amount)
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        //reset the array
        funders = new address[](0);

        //withdraw the funds - three methods
/*
        //1. Transfer (2300 gas, if it fails, it errors)
        payable(msg.sender).transfer(address(this).balance);
        
        //2. Send (2300 gas, returns bool)
        bool sendSuccess= payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");
*/
        //3. Call (forward all gas or set gas, returns bool)
        (bool callSuccess, )= payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    //Instead of adding to each function this code: require(msg.sender == owner, "Must be the owner!"); we can use a modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "Sender is not the owner");
        _; //whatever else is in the function
    }


}