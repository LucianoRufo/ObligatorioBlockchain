//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;

import "./ContratoConfiguracion.sol";



contract CuentaAhorro is ContratoConfiguracion {

    struct Ahorrista {
        string ci;
        string name;
        string lastName;
        uint256  addedDate;
        address  ahorristaAddress;
        address beneficiaryAddress;
        bool isGestor;
        bool isAuditor;
        uint debt;
        uint payed;
    }

    uint index = 0;

    address[] ahorristas;
    address[] gestores;
    address[] auditores;

    address public admin;
    address payable savingAccount;
    string public accountObjective;
    uint actualSavings;
    uint savingObjective;
    uint cantAhorristas;
    uint cantGestores;
    uint cantAuditores;
    bool accountEnabled;

    mapping(address => Ahorrista) ahorristaStructs; 


    function PublicFunction() public virtual override { publicVariable = 'PublicVariable in Cuenta ahorro'; }
    
    constructor(address payable _savingAccount) public payable {
        admin = msg.sender;
        savingAccount = _savingAccount;
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

    function addAhorrista(uint _name, address _address,address _beneficiaryAddress,  bool _isGestor, bool _isAuditor) public {
    
        ahorristas.push(_address);

        ahorristaStructs[_address] = Ahorrista(
            {
                name: _name,
                ahorristaAddress: _address,
                beneficiaryAddress: _beneficiaryAddress,
                isGestor: _isGestor,
                isAuditor: _isAuditor
            }
        );

    }


}