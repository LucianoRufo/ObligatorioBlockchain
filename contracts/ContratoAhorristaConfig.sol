//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;

import "./ContratoConfiguracion.sol";


contract ContratoAhorristaConfig is ContratoConfiguracion {


    constructor( )
      ContratoConfiguracion() public { }
 
    function addAhorristaAdmin(string memory _ci ,string memory _name,string memory _lastname, address payable _address,address payable _beneficiaryAddress,  bool _isGestor, bool _isAuditor) public onlyAdmin {
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
                toDepositOnApprove: 0, 
                isApproved: false,
                isActivated: false
            }
        );
         
    }

    function addAhorristaByDeposit(string memory _ci ,string memory _name,string memory _lastname, address payable _address,address payable _beneficiaryAddress,  bool _isGestor, bool _isAuditor, uint deposit) public  {
        //TODO: Código para hacer la transferencia y depósito
        if(deposit >= minimumDeposit){
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
                    toDepositOnApprove: deposit, //TODO: El deposito minimo sumarlo aquí
                    isApproved: false,
                    isActivated: false
                }
            );
        }
       
         
    }

    function approveSaver(address payable saverToApproveAddress) public  onlyAudit  {
        //TODO 
        ahorristaStructs[saverToApproveAddress].isApproved = true;
        if(ahorristaStructs[saverToApproveAddress].toDepositOnApprove >= minimumContribution){
            ahorristaStructs[saverToApproveAddress].isActivated = true;
            activeSavers++;
        }
        saverToApproveAddress.transfer(ahorristaStructs[saverToApproveAddress].toDepositOnApprove);
        //TODO: Check si esto funciona y transfiere al contrato, o hay que hacer variable balance etc.
        actualSavings+= ahorristaStructs[saverToApproveAddress].toDepositOnApprove;
        ahorristaStructs[saverToApproveAddress].toDepositOnApprove = 0;

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
            if (ahorristaStructs[msg.sender].payed > minimumContribution){
                ahorristaStructs[msg.sender].isActivated = true;
                activeSavers++;
            }
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