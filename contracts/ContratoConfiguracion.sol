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
   
    //Indexed event to execute and search by indexes. TODO: Vincular mejor el objetivo .
    event Execute(
        address indexed _gestorAddress,
        address indexed _objectiveAddress,
        uint _value
    );

    address[] public ahorristas;
    address[] public gestores;
    address[] public auditores;
 
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
    uint public subObjectiveCounter;
    bool public accountEnabled;
    uint public minimumContribution;
    uint public minimumDeposit;
    bool public isSavingVisible;
    bool public isVotingPeriod;
    uint public bonusPercentage;

    mapping(address => Ahorrista) public ahorristaStructs; 
    mapping(address => bool) public votedPerPeriodStruct; 
    mapping(address => bool) public closingVotesPerPeriodStruct; 


    constructor( ) public payable {
        admin = msg.sender; //TODO: Admin no puede ser ni gestor ni auditor, agregar aquí a ahorristas.
        isVotingPeriod = false;
        subObjectiveCounter = 0;
    }
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can call this function.");
        _;
    }
    modifier onlyAudit() {
        require(ahorristaStructs[msg.sender].isAuditor, "Only the auditors can call this function.");
        _;
    }

    modifier onlyGestor() {
        require(ahorristaStructs[msg.sender].isGestor, "Only the managers can call this function.");
        _;
    }

    modifier onlyAhorristaSimple() {
        require(!ahorristaStructs[msg.sender].isGestor && ahorristaStructs[msg.sender].isAuditor && msg.sender != admin, "Only the admin can call this function.");
        _;
    }

    modifier isSaverActive() {
        require(ahorristaStructs[msg.sender].payed >= minimumContribution && ahorristaStructs[msg.sender].isApproved, "Only enabled account can receive deposits");
        _;
    }
    modifier notAuditNorAdmin() {
        require( !ahorristaStructs[msg.sender].isAuditor && msg.sender != admin, "Only enabled account can receive deposits");
        _;
    }

    modifier isContractEnabled() {
        require(accountEnabled == true, "Only enabled account can receive deposits");
        _;
    }

   
    modifier onVotingPeriod() {
        require(isVotingPeriod == true, "You can only vote in voting period.");
        _;
    }
    modifier hasNotVoted() {
        require(!votedPerPeriodStruct[msg.sender] , "Only enabled account can receive deposits");
        _;
    }
    function configureContract(address payable _savingAccount, string memory _objective,uint _savingsObjective, uint  _minimumDeposit ,
    uint  _minimumContribution, bool  _isSavingVisible, uint _bonusPercentage, uint _maxCantAhorristas ) public onlyAdmin {
        savingAccount = _savingAccount;//_savingAccount
        accountObjectiveDescription = _objective;
        accountSavingsObjective = _savingsObjective;
        minimumContribution = _minimumContribution;
        minimumDeposit = _minimumDeposit;
        isSavingVisible = _isSavingVisible;
        bonusPercentage = _bonusPercentage;
        maxAhorristas = _maxCantAhorristas;
        maxGestores = maxAhorristas / 3;
        maxAuditores = maxGestores / 2;
    }
 
    
}