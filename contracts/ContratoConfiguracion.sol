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

    mapping(address => Ahorrista) public ahorristaStructs; 
    mapping(address => bool) public votedPerPeriodStruct; 
    mapping(address => bool) public closingVotesPerPeriodStruct; 


    constructor(address payable _savingAccount, string memory _objective,uint _savingsObjective, uint  _minimumDeposit ,uint  _minimumContribution, bool  _isSavingVisible ) public payable {
        admin = msg.sender; //TODO: Admin no puede ser ni gestor ni auditor, agregar aquí a ahorristas.
        savingAccount = _savingAccount;
        accountObjectiveDescription = _objective;
        accountSavingsObjective = _savingsObjective;
        minimumContribution = _minimumContribution;
        minimumDeposit = _minimumDeposit;
        isSavingVisible = _isSavingVisible;
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

    function startGestorPostulation() public onlyAdmin {
        //TODO
    }
    function startGestorVoting() public onlyAdmin {
        //TODO
    }
    function finishGestorVoting() public onlyAdmin {
        //TODO
    }

    function postulateFor(bool postulateGestor, bool postulateAuditor) public onlyAhorristaSimple isSaverActive  {
        //TODO
    }

    
}