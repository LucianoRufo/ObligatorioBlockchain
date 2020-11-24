//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;

contract ContratoConfiguracion {
   string public publicVariable;
   
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

    uint public index = 0;

    address[] public ahorristas;
    address[] public gestores;
    address[] public auditores;

    address public admin;
    address payable public savingAccount;
    string public accountObjective;
    uint public actualSavings;
    uint public savingObjective;
    uint public cantAhorristas;
    uint public cantGestores;
    uint public cantAuditores;
    bool public accountEnabled;

    mapping(address => Ahorrista) public ahorristaStructs; 


    constructor() public {
        publicVariable = 'Constructor in father';
    }
    function PublicFunction() public virtual { publicVariable = 'PublicVariable in Config'; }
}