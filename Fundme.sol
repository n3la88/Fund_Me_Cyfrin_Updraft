// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FundMe {

    uint256 public minUSD = 5;

    function fund() public payable{
        //allow users to send $5
        //have a minimum $ to send

        require(msg.value >= minUSD, "Did not send enough ETH"); // 1e18 = 1 ETH = 1000000000000000000 = 1 *10 ** 18


    }


    //function withdraw() {}

}