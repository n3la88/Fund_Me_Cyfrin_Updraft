// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "/PriceConverter.sol";

//Transaction cost when deploying contract 782,820
//constant and immutable
//when adding constant the Transaction cost goes to 761,223
contract FundMe {

    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5 * 1e10; // or  uint256 public minUSD = 5e10
    //execution cost 2446 gas - constant
    //excution cost 347 gas - non-constant
    
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;
    //execution cost 761,199 gas - immutable
    //excution cost 636,730 gas - non-immutable

    //Function that is called inmediately 
    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable{
        //allow users to send $5
        //have a minimum $ to send
        
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Did not send enough ETH"); // 1e18 = 1 ETH = 1000000000000000000 = 1 *10 ** 18
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

    //Instead of adding to each function this code: require(msg.sender == i_owner, "Must be the owner!"); we can use a modifier
    modifier onlyOwner() {
        require(msg.sender == i_owner, "Sender is not the owner");
        _; //whatever else is in the function
    }


}