//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;

import "./SubObjectiveContract.sol";

contract CuentaAhorro is SubObjectiveContract   {
    constructor(address payable _savingAccount, string memory _objective,uint _savingsObjective, uint  _minimumDeposit ,
    uint  _minimumContribution, bool  _isSavingVisible, uint _bonusPercentage )
      SubObjectiveContract(_savingAccount,_objective,_savingsObjective,_minimumDeposit,_minimumContribution,_isSavingVisible,_bonusPercentage) public { }
    
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