//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;
import "./ContratoGestorVoting.sol";

contract SubObjectiveContract is ContratoGestorVoting {
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

    event SubObjectiveCompleted(address indexed _subObjectiveAddress, string _description, uint _amount, address indexed _gestorAddress);


    address[] public votersPerPeriod;
    uint[] public subObjectives;
    mapping(uint => SubObjective) public subObjectiveStructs; 


    constructor( )
      ContratoGestorVoting() public { }  
    
    
    modifier isSubObjectiveInProcess(uint id) {
        require(subObjectiveStructs[id].state == 0 , "Only in process subobjectives can be voted");
        _;
    }

    function addSubObjective(string memory _description ,uint  _total, address payable _subObjectiveAddress) public onlyAdmin {
        address[] memory votersArray;
        subObjectives.push(subObjectiveCounter);

        subObjectiveStructs[subObjectiveCounter] = SubObjective(
            {
                id:subObjectiveCounter,
                description: _description,
                payed: 0,
                totalToPay: _total,
                state: 0,
                voters: votersArray,
                nonPrelationOrders:0,
                subObjectiveAddress: _subObjectiveAddress
            }
        );
        subObjectiveCounter++;
    }

    function startVotingPeriod() public onlyAdmin {
        isVotingPeriod = true;
    }

    function voteSubObjective(uint subObjectiveId) public onVotingPeriod isSaverActive hasNotVoted isSubObjectiveInProcess(subObjectiveId) {
        votedPerPeriodStruct[msg.sender] = true;
        subObjectiveStructs[subObjectiveId].voters.push(msg.sender);
    }

    function addClosingVote() public onlyAudit {
        closingVotesPerPeriodStruct[msg.sender] = true;
        uint arrayLength = auditores.length;
        for (uint i=0; i< arrayLength; i++) {
                if (closingVotesPerPeriodStruct[auditores[i]] == false){
                    return;
                }
        }
        closeVotingPeriod();
    }

    function closeVotingPeriod() public onlyAdmin {
        //Apruebo el subobjetivo + votado supongo => TODO: Preguntar en letra habla de varios ganadores.
        uint subObjectivesLength = subObjectives.length;
        uint mostVotes = 0;
        for (uint i=0; i< subObjectivesLength; i++) {
            SubObjective memory subObjective = subObjectiveStructs[subObjectives[i]];
            if(subObjective.state == 0 && subObjective.voters.length > mostVotes ){
                mostVotes = subObjective.voters.length;
            }
        }
        for (uint i=0; i< subObjectivesLength; i++) {
            SubObjective memory subObjective = subObjectiveStructs[subObjectives[i]];
            if( subObjective.voters.length == mostVotes ){
                subObjective.state = 1;
            }
            else {
                address[] memory newVoters;
                subObjective.voters=newVoters; //Importante borro votos de los objetivos perdedores, porque en los ganadores marca el orden de prelación.
            }
        }

        // Retorno variables de votacion a valores default
        address[] memory votersArray;
        isVotingPeriod = false;
        uint arrayLength = votersPerPeriod.length;
        for (uint i=0; i< arrayLength; i++) {
            votedPerPeriodStruct[votersPerPeriod[i]] = false;
        }
        votersPerPeriod = votersArray;

        arrayLength = auditores.length;
        for (uint i=0; i< arrayLength; i++) {
                closingVotesPerPeriodStruct[auditores[i]] = false;
        }
    }

    function executeNextSubObjective() public  onlyGestor  {
        uint subObjectivesLength = subObjectives.length;
        uint mostVotes = 0;
        bool executedSubObj = false;
        bool isFirstInPriority = true;
        SubObjective[] storage cantExecuteSubObjectives;
        //Search for next important subobjective
        while(cantExecuteSubObjectives.length < subObjectives.length || executedSubObj){
            SubObjective memory prioritizedSubObjective;
            for (uint i=0; i < subObjectivesLength; i++) {
                SubObjective memory subObjective = subObjectiveStructs[subObjectives[i]];
                if(subObjective.state == 1 && subObjective.voters.length > mostVotes && isNotInList(subObjective,cantExecuteSubObjectives) ){
                    mostVotes = subObjective.voters.length;
                    prioritizedSubObjective = subObjective;
                }
            }

            //See if it can be executed
            if(actualSavings > prioritizedSubObjective.totalToPay){
                if(isFirstInPriority){
                    actualSavings = actualSavings - prioritizedSubObjective.totalToPay;
                    prioritizedSubObjective.state = 2;
                    prioritizedSubObjective.subObjectiveAddress.transfer(prioritizedSubObjective.totalToPay);
                    executedSubObj = true;
                    emit SubObjectiveCompleted(prioritizedSubObjective.subObjectiveAddress, prioritizedSubObjective.description,prioritizedSubObjective.totalToPay, msg.sender);
                }
                else {
                    prioritizedSubObjective.nonPrelationOrders++;
                    if(prioritizedSubObjective.nonPrelationOrders >= 2){
                        actualSavings = actualSavings - prioritizedSubObjective.totalToPay;
                        prioritizedSubObjective.state = 2;
                        prioritizedSubObjective.subObjectiveAddress.transfer(prioritizedSubObjective.totalToPay);
                        executedSubObj = true;
                        emit SubObjectiveCompleted(prioritizedSubObjective.subObjectiveAddress, prioritizedSubObjective.description,prioritizedSubObjective.totalToPay, msg.sender);
                    }
                }
                
            } else {
                cantExecuteSubObjectives.push(prioritizedSubObjective);
                isFirstInPriority = false;
            }
        }
    }


    //Private - Aux functions
    function isNotInList(SubObjective memory subObjective,SubObjective[] storage cantExecuteSubObjectives) private view returns (bool)  {
        uint cantExecuteSubObjectivesLength = cantExecuteSubObjectives.length;
        for (uint i=0; i < cantExecuteSubObjectivesLength; i++) {
            SubObjective memory impossibleSubObjective = cantExecuteSubObjectives[i];
            if (impossibleSubObjective.id == subObjective.id){
                return false;
            }
        }
        return true;
    }
}