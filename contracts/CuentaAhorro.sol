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
 
}