//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;
pragma experimental ABIEncoderV2;

import "./ContratoConfiguracion.sol";


contract ContratoAhorristaConfig is ContratoConfiguracion {

    modifier saverIsOnTime() {  
        require(now -  mappings.deathReports[msg.sender].dateApproved < config.timeToReportLife, "The time to report life was ended.");
        _;
    }

    modifier saverWasReportedAndOutOfTime() {  
        require( mappings.deathReports[msg.sender].exist && now -  mappings.deathReports[msg.sender].dateApproved >= config.timeToReportLife, "This user can't be deleted");
        _;
    }

    constructor( )
      ContratoConfiguracion() public { }
     
    function addAhorristaAdmin(AhorristaIn memory ahorristaIn) public onlyAdmin {
        ahorristas.push(ahorristaIn._address);

         mappings.ahorristaStructs[ahorristaIn._address] = Ahorrista(
            {
                ci: ahorristaIn._ci,
                name: ahorristaIn._name,
                lastName: ahorristaIn._lastname,
                addedDate: now,
                ahorristaAddress: ahorristaIn._address,
                beneficiaryAddress: ahorristaIn._beneficiaryAddress,
                isGestor: ahorristaIn._isGestor,
                isAuditor: ahorristaIn._isAuditor,
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

    function addAhorristaByDeposit(AhorristaIn memory ahorristaIn, uint deposit) public  {
        //uint256 amount = msg.value; //Testear así
        if(deposit >= config.minimumDeposit){
            ahorristas.push(ahorristaIn._address);

             mappings.ahorristaStructs[ahorristaIn._address] = Ahorrista(
                {
                    ci: ahorristaIn._ci,
                    name: ahorristaIn._name,
                    lastName: ahorristaIn._lastname,
                    addedDate: now,
                    ahorristaAddress: ahorristaIn._address,
                    beneficiaryAddress: ahorristaIn._beneficiaryAddress,
                    isGestor: ahorristaIn._isGestor,
                    isAuditor: ahorristaIn._isAuditor,
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

            savingAccount.transfer(deposit);
            config.actualSavings+=deposit;
        }
       
         
    }

    function approveSaver(address payable saverToApproveAddress) public  onlyAudit  {
        mappings.ahorristaStructs[saverToApproveAddress].isApproved = true;
        if( mappings.ahorristaStructs[saverToApproveAddress].toDepositOnApprove >= config.minimumContribution){
             mappings.ahorristaStructs[saverToApproveAddress].isActivated = true;
            config.activeSavers++;
        }
        savingAccount.transfer( mappings.ahorristaStructs[saverToApproveAddress].toDepositOnApprove);
        config.actualSavings+=  mappings.ahorristaStructs[saverToApproveAddress].toDepositOnApprove;
        mappings.ahorristaStructs[saverToApproveAddress].toDepositOnApprove = 0;

    }

    function askBalancePermission() public  notAuditNorAdmin  {
         mappings.permissionRequestsToSolve[msg.sender] = true;
    }

    function giveBalancePermission(address saverToApprove) public  auditOrAdmin  {
        if( mappings.permissionRequestsToSolve[saverToApprove] ){
             mappings.permissionRequestsToSolve[saverToApprove] = false;
             mappings.ahorristaStructs[saverToApprove].canSeeBalance = true;
        }
    }

    function removeBalancePermission(address saverToApprove) public  auditOrAdmin  {
        mappings.ahorristaStructs[saverToApprove].canSeeBalance = true;
    }

    function askForLoan(uint amount) public  isSaverActive  {
        if( amount <= config.maxLoan){
            mappings.loans[msg.sender] = Loan(
                {
                    saver: msg.sender,
                    debt: amount,
                    payments: 0,
                    actualDebt: amount 
                }
            );
            mappings.ahorristaStructs[msg.sender].debt = amount;
            mappings.ahorristaStructs[msg.sender].isActivated = false;
            msg.sender.transfer(amount);
            config.actualSavings-=amount;
            emit LoanEvent(msg.sender, amount);
        }
    }

    function retireFromFund(bool retireWithoutWithdrawal) public  isSaverActive hasNoDebts  {
        //TODO: Chequear si el retirado es admin / gestor / auditor -> abrir inscripciones y disparar votación de alguna forma.
        if(retireWithoutWithdrawal){
            mappings.ahorristaStructs[msg.sender].isRetired = true;
        } else {
            uint amountToReturn = mappings.ahorristaStructs[msg.sender].payed / 100 * config.percentageForRetirements;
            if(config.actualSavings >= amountToReturn){
                mappings.ahorristaStructs[msg.sender].isRetired = true;
                config.actualSavings-=amountToReturn;
                msg.sender.transfer(amountToReturn);
            }
        }
    }
    
    function reportSaverDeath(address saver) public  onlyGestor  {
        if(mappings.deathReports[saver].exist){
            mappings.deathReports[saver].gestorApprovals++;
            if(mappings.deathReports[saver].gestorApprovals >= 2){
                mappings.deathReports[saver].dateApproved = now;
            }
        } else {
            mappings.deathReports[saver] = DeathReport({
                saver: saver,
                gestorApprovals: 0,
                exist: true,
                dateApproved: now
            });
        }
    }

    function revokeDeath( ) public saverIsOnTime   {
        mappings.deathReports[msg.sender].gestorApprovals = 0;
        mappings.deathReports[msg.sender].exist = false;
    }

    function closeDeadSaverAccount(address payable _saver) public  onlyGestor saverWasReportedAndOutOfTime  {
        //TODO: Chequear si el retirado es admin / gestor / auditor -> abrir inscripciones y disparar votación de alguna forma.
        uint amountToReturn = mappings.ahorristaStructs[_saver].payed / 100 * config.percentageForRetirements -  mappings.ahorristaStructs[_saver].debt;
        if(config.actualSavings >= amountToReturn &&  amountToReturn > 0){
            mappings.ahorristaStructs[_saver].isRetired = true;
            mappings.ahorristaStructs[_saver].isActivated = false;
            mappings.ahorristaStructs[_saver].isApproved = false;
            config.actualSavings-=amountToReturn;
            _saver.transfer(amountToReturn);
        }
    }
 
    function makeContribution( uint amount, bool payRecharge) public isContractEnabled   {
        if( amount > config.minimumDeposit ){
            if(now - mappings.ahorristaStructs[msg.sender].lastPaymentDate < 1000 * 60 * 60 * 24 * 60 ){
                if(payRecharge){
                    amount+= config.recargoMoroso;
                    savingAccount.transfer(amount);
                    mappings.ahorristaStructs[msg.sender].payed+=amount;
                    if (mappings.ahorristaStructs[msg.sender].payed > config.minimumContribution){
                        mappings.ahorristaStructs[msg.sender].isActivated = true;
                        mappings.ahorristaStructs[msg.sender].lastPaymentDate = now; 
                        config.activeSavers++;
                    }
                }
            }else {
                savingAccount.transfer(amount);
                mappings.ahorristaStructs[msg.sender].payed+=amount;
                if (mappings.ahorristaStructs[msg.sender].payed > config.minimumContribution){
                    mappings.ahorristaStructs[msg.sender].isActivated = true;
                    mappings.ahorristaStructs[msg.sender].lastPaymentDate = now; 
                    config.activeSavers++;
                }
            }
        }
    }

    function payDebt(uint amount ) public    {
        mappings.ahorristaStructs[msg.sender].debt = mappings.ahorristaStructs[msg.sender].debt - amount;
        mappings.ahorristaStructs[msg.sender].lastPaymentDate = now;
        mappings.loans[msg.sender].payments+= amount;
        mappings.loans[msg.sender].actualDebt-= amount;
        savingAccount.transfer(amount);
    }


}