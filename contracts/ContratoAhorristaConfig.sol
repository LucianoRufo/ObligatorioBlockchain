//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;

import "./ContratoConfiguracion.sol";


contract ContratoAhorristaConfig is ContratoConfiguracion {

   struct Loan {
        address saver;
        uint debt;
        uint payments;
        uint actualDebt;
    }
    mapping(address => Loan) public loans; 

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
                isActivated: false,
                canSeeBalance: false,
                lastPaymentDate: now,
                isRetired: false
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
                    isActivated: false,
                    canSeeBalance: false,
                    lastPaymentDate: now,
                    isRetired: false
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

    function askBalancePermission() public  notAuditNorAdmin  {
        permissionRequestsToSolve[msg.sender] = true;
    }

    function giveBalancePermission(address saverToApprove) public  auditOrAdmin  {
        if(permissionRequestsToSolve[saverToApprove] ){
            permissionRequestsToSolve[saverToApprove] = false;
            ahorristaStructs[saverToApprove].canSeeBalance = true;
        }
    }

    function removeBalancePermission(address saverToApprove) public  auditOrAdmin  {
        ahorristaStructs[saverToApprove].canSeeBalance = true;
    }

    function askForLoan(uint amount) public  isSaverActive  {
        //TODO: Transfer logic & emit event
        if( amount <= maxLoan){
            loans[msg.sender] = Loan(
                {
                    saver: msg.sender,
                    debt: amount,
                    payments: 0,
                    actualDebt: amount 
                }
            );
            ahorristaStructs[msg.sender].debt = amount;
            ahorristaStructs[msg.sender].isActivated = false;
        }
    }

    function retireFromFund(bool retireWithoutWithdrawal) public  isSaverActive hasNoDebts  {
        //TODO: Chequear si el retirado es admin / gestor / auditor -> abrir inscripciones y disparar votación de alguna forma.
        if(retireWithoutWithdrawal){
            ahorristaStructs[msg.sender].isRetired = true;
        } else {
            uint amountToReturn = ahorristaStructs[msg.sender].payed / 100 * percentageForRetirements;
            if(actualSavings >= amountToReturn){
                ahorristaStructs[msg.sender].isRetired = true;
                actualSavings-=amountToReturn;
                //TODO: Code to transfer from the savings to the address.
            }
        }
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
 
    function makeContribution( uint amount, bool payRecharge) public isContractEnabled   {
        if( amount > minimumDeposit ){
            if(now - ahorristaStructs[msg.sender].lastPaymentDate < 1000 * 60 * 60 * 24 * 60 ){
                if(payRecharge){
                    amount+= recargoMoroso;
                    savingAccount.transfer(amount);
                    ahorristaStructs[msg.sender].payed+=amount;
                    if (ahorristaStructs[msg.sender].payed > minimumContribution){
                        ahorristaStructs[msg.sender].isActivated = true;
                        ahorristaStructs[msg.sender].lastPaymentDate = now; 
                        activeSavers++;
                    }
                }
            }else {
                savingAccount.transfer(amount);
                ahorristaStructs[msg.sender].payed+=amount;
                if (ahorristaStructs[msg.sender].payed > minimumContribution){
                    ahorristaStructs[msg.sender].isActivated = true;
                    ahorristaStructs[msg.sender].lastPaymentDate = now; 
                    activeSavers++;
                }
            }
        }
        //TODO Execute the contract if objective is reached
    }

    function payDebt(uint amount ) public    {
        ahorristaStructs[msg.sender].debt = ahorristaStructs[msg.sender].debt - amount;
        ahorristaStructs[msg.sender].lastPaymentDate = now;
        loans[msg.sender].payments+= amount;
        loans[msg.sender].actualDebt-= amount;
        savingAccount.transfer(amount);
    }

    function closeContract( ) public  onlyAdmin  {
        //TODO
    }
}