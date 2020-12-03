//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;
pragma experimental ABIEncoderV2;
import "./SubObjectiveContract.sol";
 
contract CuentaAhorro is SubObjectiveContract   {
  constructor()
    SubObjectiveContract() public { }
  
  function getBalance() public canSeeBalance view  returns(uint256){
      return config.actualSavings;
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