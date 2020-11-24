//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;

import "./ContratoConfiguracion.sol";



contract CuentaAhorro is ContratoConfiguracion {
    

    function PublicFunction() public virtual override { publicVariable = 'PublicVariable in Cuenta ahorro'; }
    
    constructor(address payable _savingAccount, string memory _objective) public payable {
        admin = msg.sender;
        savingAccount = _savingAccount;
        accountObjective = _objective;
    }

    modifier isEnabled() {
        require(accountEnabled == true, "Only enabled account can receive deposit");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can call this function.");
        _;
    }

    function sum(uint x, uint y) public pure returns(uint){
        return x + y;
    }

    function getBalance() public view onlyAdmin returns(uint256){
        return address(this).balance;
    }

    function getAdminBalance() public view onlyAdmin returns (uint) {
        return admin.balance;
    }

    function transfer() public onlyAdmin {
        uint balance = address(this).balance;
        savingAccount.transfer(balance);
    }

    function addAhorrista(string memory _ci ,string memory _name,string memory _lastname, address _address,address _beneficiaryAddress,  bool _isGestor, bool _isAuditor) public {
    
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
                debt: 0,//TODO: Add variable minimum
                payed: 0
            }
        );
         
    }


}