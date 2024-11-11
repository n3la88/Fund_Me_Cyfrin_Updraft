// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FundMe {

    function fund() public payable{
        //allow users to send $
        //have a minimum $ to send

        require(msg.value > 1e18, "Did not send enough ETH"); // 1e18 = 1 ETH = 1000000000000000000 = 1 *10 ** 18


    }


    //function withdraw() {}

}