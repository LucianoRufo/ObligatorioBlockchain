//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;
pragma experimental ABIEncoderV2;

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
        uint commissionPercentage;
    }

    struct ConfigIn {
        address payable _savingAccount; 
        string _objective;
        uint _savingsObjective; 
        uint  _minimumDeposit ;
        uint  _minimumContribution; 
        bool  _isSavingVisible; 
        uint _bonusPercentage; 
        uint _maxCantAhorristas;
        uint _maxLoan;
        uint _recargoMoroso; 
        uint _percentageForRetirements; 
        uint _timeToReportLife;
        uint _commissionPercentage;
        address payable _companyToPay;
    }
    struct Loan {
        address saver;
        uint debt;
        uint payments;
        uint actualDebt;
    }
    struct DeathReport {
        address saver;
        uint gestorApprovals;
        bool exist;
        uint256 dateApproved;
    }

    struct AhorristaIn {
        string _ci; 
        string _name;
        string _lastname;
        address payable _address;
        address payable _beneficiaryAddress;
        bool _isGestor;
        bool _isAuditor;
    }

    struct Postulation {
        address  postulatorAddress;
        bool runsForGestor;
        bool runsForAudit;
        uint votesForGestor;
        uint votesForAudit;
    }
 
    struct VoteLog {
        bool votedGestor;
        bool votedAudit;
        bool exists;
    }
    struct SubObjective {
        uint id; 
        string description;   
        address payable subObjectiveAddress;
        uint payed;
        uint totalToPay; 
        uint state; // {0, 1 , 2} = { En proceso, Aprobado, Ejecutado}
        address[] voters; //También podía ser otro mapping
        uint nonPrelationOrders;
    }
    struct Mappings {
        mapping(address => Ahorrista) ahorristaStructs; 
        mapping(address => bool) votedPerPeriodStruct; 
        mapping(address => bool) closingVotesPerPeriodStruct; 
        mapping(address => bool) permissionRequestsToSolve; 
        mapping(address => bool) closeContractVotes; 
        mapping(address => Loan) loans; 
        mapping(address => DeathReport) deathReports; 
        mapping(address => Postulation) postulatedSaversStructs; 
        mapping(address => VoteLog) votedLogs; 
        mapping(uint => SubObjective) subObjectiveStructs; 
    }
   
    event LoanEvent(address indexed _saver,  uint _debt);
    event SubObjectiveCompleted(address indexed _subObjectiveAddress, string _description, uint _amount, address indexed _gestorAddress);
    ConfigVars  config;
    Mappings  mappings;

    address[]  ahorristas;
    address[] gestores;
    address[] auditores;
    address[] gestorVotersPerPeriod;
    address[] postulatedSaversArray;
    address[] votersPerPeriod;

    uint[]  subObjectives;
    uint approvedObjectives;

    address payable public admin;
    address payable public savingAccount;
    address payable public companyToPay;

    bool  isGestorVotingPeriod;
    bool  isGestorPostulationPeriod;

    address[]  closeContractVoters;

   

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
                timeToReportLife:1000 * 60 * 60 * 24 * 7,
                commissionPercentage: 10
            }
        );
    }
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can call this function.");
        _;
    }
    modifier onlyAudit() {
        require(mappings.ahorristaStructs[msg.sender].isAuditor, "Only the auditors can call this function.");
        _;
    }

    modifier auditOrAdmin() {
        require(mappings.ahorristaStructs[msg.sender].isAuditor || msg.sender == admin, "Only the auditor or admin can call this function.");
        _;
    }

    modifier onlyGestor() {
        require(mappings.ahorristaStructs[msg.sender].isGestor, "Only the managers can call this function.");
        _;
    }

    modifier onlyAhorristaSimple() {
        require(!mappings.ahorristaStructs[msg.sender].isGestor && mappings.ahorristaStructs[msg.sender].isAuditor && msg.sender != admin, "Only the admin can call this function.");
        _;
    }

    modifier isSaverActive() {
        require(mappings.ahorristaStructs[msg.sender].payed >= config.minimumContribution && mappings.ahorristaStructs[msg.sender].isApproved, "Only enabled account can receive deposits");
        _;
    }
    modifier notAuditNorAdmin() {
        require( !mappings.ahorristaStructs[msg.sender].isAuditor && msg.sender != admin, "Only enabled account can receive deposits");
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
        require(!mappings.votedPerPeriodStruct[msg.sender] , "Only enabled account can receive deposits");
        _;
    }

    modifier canSeeBalance() {
        require(msg.sender == admin || mappings.ahorristaStructs[msg.sender].isAuditor || mappings.ahorristaStructs[msg.sender].canSeeBalance, "Only enabled account can see the balance");
        _;
    }

    modifier hasNotVotedClose() {
        require(!mappings.closeContractVotes[msg.sender], "You can only vote to close once.");
        _;
    }

    modifier hasNoDebts() {
        require(mappings.ahorristaStructs[msg.sender].debt > 0, "Only enabled account can see the balance");
        _;
    }

    modifier allActiveVoted() {
        require(closeContractVoters.length == config.activeSavers, "Not all active savers voted");
        _;
    }
    modifier enoughSavers() {
        require(config.cantAuditores >= config.cantGestores / 2 && config.cantGestores >= config.cantAhorristas / 3  , "Not all active savers voted");
        _;
    }

    function configureContract( ConfigIn memory configVarsIn ) public onlyAdmin {
        
        savingAccount = configVarsIn._savingAccount;//_savingAccount
        config.accountObjectiveDescription = configVarsIn._objective;
        config.accountSavingsObjective = configVarsIn._savingsObjective;
        config.minimumContribution = configVarsIn._minimumContribution;
        config.minimumDeposit = configVarsIn._minimumDeposit;
        config.isSavingVisible =configVarsIn._isSavingVisible;
        config.bonusPercentage = configVarsIn._bonusPercentage;
        if(configVarsIn._maxCantAhorristas >= 6 ){
            config.maxAhorristas = configVarsIn._maxCantAhorristas;
            config.maxGestores = config.maxAhorristas / 3;
            config.maxAuditores = config.maxGestores / 2;
        }
        config.maxLoan =configVarsIn._maxLoan;
        config.recargoMoroso = configVarsIn._recargoMoroso;
        config.percentageForRetirements = configVarsIn._percentageForRetirements;
        config.timeToReportLife = configVarsIn._timeToReportLife;
        config.commissionPercentage = configVarsIn._commissionPercentage;
        companyToPay = configVarsIn._companyToPay;
    }

    function enableContract( ) public onlyAdmin enoughSavers {
        config.accountEnabled = true;
    }


}