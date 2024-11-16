// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

//Transaction cost when deploying contract 782,820
//constant and immutable
//when adding constant the Transaction cost goes to 761,223

library PriceConverter {

      function getPrice() internal view returns(uint256) {
        // Address 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        ( , int256 answer,  ,  ,  ) = priceFeed.latestRoundData();
        // Price of ETH in terms of USD
        // 2000000000000000000
        return uint256(answer * 1e10);
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256){
        // 1 ETH???
        // The answer = 2000_000000000000000000
        uint256 ethPrice = getPrice();
        // 2000_000000000000000000 * 1_000000000000000000 / 1e10;
        // $2000 = 1 ETH
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e10;
        return ethAmountInUSD;
    }

    function getVersion() internal view returns (uint256){
        return AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF).version();
    }
}

error NotOwner();

contract FundMeZk {

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
      //  require(msg.sender == i_owner, "Sender is not the owner");
      // to save gas we can use the error
      if(msg.sender != i_owner){revert NotOwner();}
        _; //whatever else is in the function
    }

    // What happens if someone sends this contract ETH without calling the fund function

    // receive()
    // fallback()

    receive() external payable {
        fund();
    }

    fallback() external payable{
        fund();
    }

}