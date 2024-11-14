// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeMathTester {
    
    uint8 public bigNumber = 255;

    function add() public {
        bigNumber = bigNumber + 1;
    } 

    //The same happens if you use a newer version but wrap the function within "unchecked"

    //Unchecked makes the transaction more gas efficient

    function addUnchecked() public {
        unchecked {bigNumber = bigNumber + 1;}
    }
}