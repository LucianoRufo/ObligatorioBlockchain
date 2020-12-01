//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;

contract ContratoConfiguracion {

   struct Ahorrista {
        string ci;
        string name;
        string lastName;
        uint256  addedDate;
        address payable  ahorristaAddress;
        address payable beneficiaryAddress;
        bool isGestor;
        bool isAuditor;
        uint debt;
        uint payed;
        uint toDepositOnApprove;
        bool isApproved;
        bool isActivated;
        bool canSeeBalance;
        uint256 lastPaymentDate;
        bool isRetired;
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
 
    address payable public admin;
    address payable public savingAccount;

    string public accountObjectiveDescription;
    uint public accountSavingsObjective;
    uint public actualSavings;

    bool public accountEnabled;

    uint public cantAhorristas;
    uint public maxAhorristas;
    uint public cantGestores;
    uint public maxGestores;
    uint public cantAuditores;
    uint public maxAuditores;
    uint public subObjectiveCounter;
    uint public minimumContribution;
    uint public minimumDeposit;
    bool public isSavingVisible;
    bool public isVotingPeriod;
    uint public bonusPercentage;
    uint public activeSavers;
    uint public maxLoan;
    uint public recargoMoroso;
    uint public percentageForRetirements;
    uint256 public timeToReportLife;

    mapping(address => Ahorrista) public ahorristaStructs; 
    mapping(address => bool) public votedPerPeriodStruct; 
    mapping(address => bool) public closingVotesPerPeriodStruct; 
    mapping(address => bool) public permissionRequestsToSolve; 


    constructor( ) public payable {
        admin = msg.sender; //TODO: Admin no puede ser ni gestor ni auditor, agregar aquí a ahorristas.
        isVotingPeriod = false;
        subObjectiveCounter = 0;
        actualSavings = 0;
        maxAhorristas = 6;
        maxGestores = maxAhorristas / 3;
        maxAuditores = maxGestores / 2;
        activeSavers = 0;
    }
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can call this function.");
        _;
    }
    modifier onlyAudit() {
        require(ahorristaStructs[msg.sender].isAuditor, "Only the auditors can call this function.");
        _;
    }

    modifier auditOrAdmin() {
        require(ahorristaStructs[msg.sender].isAuditor || msg.sender == admin, "Only the auditor or admin can call this function.");
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

    modifier canSeeBalance() {
        require(msg.sender == admin || ahorristaStructs[msg.sender].isAuditor || ahorristaStructs[msg.sender].canSeeBalance, "Only enabled account can see the balance");
        _;
    }

    modifier hasNoDebts() {
        require(ahorristaStructs[msg.sender].debt > 0, "Only enabled account can see the balance");
        _;
    }

    function configureContract(address payable _savingAccount, string memory _objective,uint _savingsObjective, uint  _minimumDeposit ,
        uint  _minimumContribution, bool  _isSavingVisible, uint _bonusPercentage, uint _maxCantAhorristas, uint _maxLoan,uint _recargoMoroso, 
        uint _percentageForRetirements, uint _timeToReportLife ) public onlyAdmin {
        
        savingAccount = _savingAccount;//_savingAccount
        accountObjectiveDescription = _objective;
        accountSavingsObjective = _savingsObjective;
        minimumContribution = _minimumContribution;
        minimumDeposit = _minimumDeposit;
        isSavingVisible = _isSavingVisible;
        bonusPercentage = _bonusPercentage;
        if(_maxCantAhorristas >= 6 ){
            maxAhorristas = _maxCantAhorristas;
            maxGestores = maxAhorristas / 3;
            maxAuditores = maxGestores / 2;
        }
        maxLoan = _maxLoan;
        recargoMoroso = _recargoMoroso;
        percentageForRetirements = _percentageForRetirements;
        timeToReportLife = _timeToReportLife;
    }

    function enableContract( ) public onlyAdmin {
        //TODO: verificar condiciones -> si hay suficientes ahorristas, gestores y auditores.
        accountEnabled = true;
    }
}