//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;

contract ContratoConfiguracion {

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
        bool isApproved;
    }

    struct SubObjective {
        string description;
        uint payed;
        uint totalToPay;
        uint state; // {0, 1 , 2} = { en proceso, Aprobado, Ejecutado}
    }

    address[] public ahorristas;
    address[] public gestores;
    address[] public auditores;
    SubObjective[] public subObjectives;

    address public admin;
    address payable public savingAccount;
    string public accountObjectiveDescription;
    uint public accountSavingsObjective;

    uint public actualSavings;
    uint public savingObjective;
    uint public cantAhorristas;
    uint public maxAhorristas;
    uint public cantGestores;
    uint public maxGestores;
    uint public maxAuditores;
    bool public accountEnabled;
    uint public minimumContribution;
    uint public minimumDeposit;
    bool public isSavingVisible;

    mapping(address => Ahorrista) public ahorristaStructs; 


    constructor(address payable _savingAccount, string memory _objective,uint _savingsObjective, uint  _minimumDeposit ,uint  _minimumContribution, bool  _isSavingVisible ) public payable {
        admin = msg.sender; //TODO: Admin no puede ser ni gestor ni auditor, agregar aquí a ahorristas.
        savingAccount = _savingAccount;
        accountObjectiveDescription = _objective;
        accountSavingsObjective = _savingsObjective;
        minimumContribution = _minimumContribution;
        minimumDeposit = _minimumDeposit;
        isSavingVisible = _isSavingVisible;
        
    }


    modifier isSaverActive(address saverAddress) {
        require(ahorristaStructs[saverAddress].payed >= minimumContribution && ahorristaStructs[saverAddress].isApproved, "Only enabled account can receive deposits");
        _;
    }

    modifier isContractEnabled() {
        require(accountEnabled == true, "Only enabled account can receive deposits");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can call this function.");
        _;
    }

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


    function addSubObjective(string memory _description ,uint  _total) public onlyAdmin {
    
        subObjectives.push(SubObjective(
            {
                description: _description,
                payed: 0,
                totalToPay: _total,
                state: 0
            }
        ));
    }



}