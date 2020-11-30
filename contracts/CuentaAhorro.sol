//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;

import "./SubObjectiveContract.sol";

contract CuentaAhorro is SubObjectiveContract   {
    constructor()
      SubObjectiveContract() public { }
    
    function getBalance() public view  returns(uint256){
        return address(this).balance;
    }
 
    function transfer() public onlyAdmin {
        uint balance = address(this).balance;
        savingAccount.transfer(balance/2);
    }

    function sum() public  {
        //uint balance = address(this).balance;
        savingAccount.transfer(4);
    }
}