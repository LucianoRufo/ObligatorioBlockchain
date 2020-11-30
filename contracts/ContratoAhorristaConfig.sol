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
                payed: 0,
                isApproved: false
            }
        );
         
    }

    function startGestorPostulation() public onlyAdmin {
        //TODO
    }
    function startGestorVoting() public onlyAdmin {
        //TODO
    }
    function finishGestorVoting() public onlyAdmin {
        //TODO
    }

    function postulateFor(bool postulateGestor, bool postulateAuditor) public onlyAhorristaSimple isSaverActive  {
        //TODO
    }

    function askSavingPermission() public  notAuditNorAdmin  {
        //TODO 
    }
    function askForLoan() public  isSaverActive  {
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

    function makeContribution( ) public    {
        //TODO
    }
    function payDebt( ) public    {
        //TODO
    }
    function closeContract( ) public  onlyAdmin  {
        //TODO
    }
}