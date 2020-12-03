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

    struct ConfigVars {
        string  accountObjectiveDescription;
        uint  accountSavingsObjective;
        uint  actualSavings;
        bool  accountEnabled;
        uint  cantAhorristas;
        uint  maxAhorristas;
        uint  cantGestores;
        uint  maxGestores;
        uint  cantAuditores;
        uint  maxAuditores;
        uint  subObjectiveCounter;
        uint  minimumContribution;
        uint  minimumDeposit;
        bool  isSavingVisible;
        bool  isVotingPeriod;
        uint  bonusPercentage;
        uint  activeSavers;
        uint  maxLoan;
        uint  recargoMoroso;
        uint  percentageForRetirements;
        uint256  timeToReportLife;
    }

    address[] public ahorristas;
    address[] public gestores;
    address[] public auditores;

    address payable public admin;
    address payable public savingAccount;

    ConfigVars public config;

    address[] public closeContractVoters;

    mapping(address => Ahorrista) public ahorristaStructs; 
    mapping(address => bool) public votedPerPeriodStruct; 
    mapping(address => bool) public closingVotesPerPeriodStruct; 
    mapping(address => bool) public permissionRequestsToSolve; 
    mapping(address => bool) public closeContractVotes; 


    constructor( ) public payable {
        admin = msg.sender; //TODO: Admin no puede ser ni gestor ni auditor, agregar aquí a ahorristas.
        config = ConfigVars(
            {
                isVotingPeriod: false,
                subObjectiveCounter: 0,
                actualSavings: 0,
                maxAhorristas: 6,
                maxGestores: 6 / 3,
                maxAuditores: 2 / 2,
                activeSavers: 0,
                accountObjectiveDescription:"",
                accountSavingsObjective:0,
                accountEnabled:false,
                cantAhorristas:0,
                cantGestores:0,
                cantAuditores:0,
                minimumContribution:100,
                minimumDeposit:50,
                isSavingVisible:false,
                bonusPercentage:10,
                maxLoan:200,
                recargoMoroso:50,
                percentageForRetirements:15,
                timeToReportLife:1000 * 60 * 60 * 24 * 7
            }
        );
       
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
        require(ahorristaStructs[msg.sender].payed >= config.minimumContribution && ahorristaStructs[msg.sender].isApproved, "Only enabled account can receive deposits");
        _;
    }
    modifier notAuditNorAdmin() {
        require( !ahorristaStructs[msg.sender].isAuditor && msg.sender != admin, "Only enabled account can receive deposits");
        _;
    }

    modifier isContractEnabled() {
        require(config.accountEnabled == true, "Only enabled account can receive deposits");
        _;
    }

   
    modifier onVotingPeriod() {
        require(config.isVotingPeriod == true, "You can only vote in voting period.");
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

    modifier hasNotVotedClose() {
        require(!closeContractVotes[msg.sender], "You can only vote to close once.");
        _;
    }

    modifier hasNoDebts() {
        require(ahorristaStructs[msg.sender].debt > 0, "Only enabled account can see the balance");
        _;
    }

    modifier allActiveVoted() {
        require(closeContractVoters.length == config.activeSavers, "Not all active savers voted");
        _;
    }


    function configureContract(address payable _savingAccount, string memory _objective,uint _savingsObjective, uint  _minimumDeposit ,
        uint  _minimumContribution, bool  _isSavingVisible, uint _bonusPercentage, uint _maxCantAhorristas, uint _maxLoan,uint _recargoMoroso, 
        uint _percentageForRetirements, uint _timeToReportLife ) public onlyAdmin {
        
        savingAccount = _savingAccount;//_savingAccount
        config.accountObjectiveDescription = _objective;
        config.accountSavingsObjective = _savingsObjective;
        config.minimumContribution = _minimumContribution;
        config.minimumDeposit = _minimumDeposit;
        config.isSavingVisible = _isSavingVisible;
        config.bonusPercentage = _bonusPercentage;
        if(_maxCantAhorristas >= 6 ){
            config.maxAhorristas = _maxCantAhorristas;
            config.maxGestores = config.maxAhorristas / 3;
            config.maxAuditores = config.maxGestores / 2;
        }
        config.maxLoan = _maxLoan;
        config.recargoMoroso = _recargoMoroso;
        config.percentageForRetirements = _percentageForRetirements;
        config.timeToReportLife = _timeToReportLife;
    }

    function enableContract( ) public onlyAdmin {
        //TODO: verificar condiciones -> si hay suficientes ahorristas, gestores y auditores.
        config.accountEnabled = true;
    }


}