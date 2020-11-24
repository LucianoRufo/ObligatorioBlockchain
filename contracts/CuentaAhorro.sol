//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;

import "./ContratoConfiguracion.sol";

contract CuentaAhorro is ContratoConfiguracion {
    constructor(address payable _savingAccount, string memory _objective,uint _savingsObjective, uint  _minimumDeposit ,uint  _minimumContribution, bool  _isSavingVisible )
      ContratoConfiguracion(_savingAccount,_objective,_savingsObjective,_minimumDeposit,_minimumContribution,_isSavingVisible) public { }

    
 
    function getBalance() public view onlyAdmin returns(uint256){
        return address(this).balance;
    }
 
    function transfer() public onlyAdmin {
        uint balance = address(this).balance;
        savingAccount.transfer(balance);
    }

   

}