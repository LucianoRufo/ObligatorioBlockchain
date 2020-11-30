//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;

import "./ContratoConfiguracion.sol";


contract ContratoAhorristaConfig is ContratoConfiguracion {


    constructor( )
      ContratoConfiguracion() public { }
 
    function addAhorristaAdmin(string memory _ci ,string memory _name,string memory _lastname, address _address,address _beneficiaryAddress,  bool _isGestor, bool _isAuditor) public onlyAdmin {
        ahorristas.push(_address);

        ahorristaStructs[_address] = Ahorrista(
            {
                ci: _ci,
                name: _name,
                lastName: _lastname,
                addedDate: now,
                ahorristaAddress: _address,
                beneficiaryAddress: _beneficiaryAddress,
                isGestor: _isGestor,
                isAuditor: _isAuditor,
                debt: 0, //TODO: Add variable minimum
                payed: 0,
                isApproved: true
            }
        );
         
    }

    function addAhorristaByDeposit(string memory _ci ,string memory _name,string memory _lastname, address _address,address _beneficiaryAddress,  bool _isGestor, bool _isAuditor) public  {
        //TODO: Código para hacer la transferencia y depósito
        ahorristas.push(_address);

        ahorristaStructs[_address] = Ahorrista(
            {
                ci: _ci,
                name: _name,
                lastName: _lastname,
                addedDate: now,
                ahorristaAddress: _address,
                beneficiaryAddress: _beneficiaryAddress,
                isGestor: _isGestor,
                isAuditor: _isAuditor,
                debt: 0, //TODO: Add variable minimum
                payed: 0, //TODO: El deposito minimo sumarlo aquí
                isApproved: false
            }
        );
         
    }


    function askSavingPermission() public  notAuditNorAdmin  {
        //TODO 
    }
    function askForLoan(uint amount) public  isSaverActive  {
        //TODO
    }

    function retireFromFund() public  isSaverActive  {
        //TODO
    }
    function reportSaverDeath(address _saver) public  onlyGestor  {
        //TODO
    }
    function revokeDeath( ) public   {
        //TODO
    }
    function closeDeadSaverAccount(address _saver) public  onlyGestor  {
        //TODO
    }

    function makeContribution( uint amount) public isContractEnabled   {
        if( amount > minimumDeposit){
            savingAccount.transfer(amount);
            ahorristaStructs[msg.sender].payed+=amount;
        }
        //TODO Execute the contract if objective is reached
    }
    function payDebt( ) public    {
        uint amount = ahorristaStructs[msg.sender].debt;
        savingAccount.transfer(amount);
    }
    function closeContract( ) public  onlyAdmin  {
        //TODO
    }
}