//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;
import "./ContratoConfiguracion.sol";

contract SubObjectiveContract is ContratoConfiguracion {
     struct SubObjective {
        uint id;
        string description; 
        uint payed;
        uint totalToPay; 
        uint state; // {0, 1 , 2} = { en proceso, Aprobado, Ejecutado}
        address[] voters; //También podía ser otro mapping
        uint nonPrelationOrders;
    }

    address[] public votersPerPeriod;
    uint[] public subObjectives;
    mapping(uint => SubObjective) public subObjectiveStructs; 


    constructor(address payable _savingAccount, string memory _objective,uint _savingsObjective, uint  _minimumDeposit ,uint  _minimumContribution, bool  _isSavingVisible )
      ContratoConfiguracion(_savingAccount,_objective,_savingsObjective,_minimumDeposit,_minimumContribution,_isSavingVisible) public { }
    
    
    modifier isSubObjectiveInProcess(uint id) {
        require(subObjectiveStructs[id].state == 0 , "Only in process subobjectives can be boted");
        _;
    }
    
    function addSubObjective(string memory _description ,uint  _total) public onlyAdmin {
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
                nonPrelationOrders:0
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
        uint arrayLength = gestores.length;
        for (uint i=0; i< arrayLength; i++) {
                if (closingVotesPerPeriodStruct[gestores[i]] == false){
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

        arrayLength = gestores.length;
        for (uint i=0; i< arrayLength; i++) {
                closingVotesPerPeriodStruct[gestores[i]] = false;
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
                if(subObjective.state == 0 && subObjective.voters.length > mostVotes && isNotInList(subObjective,cantExecuteSubObjectives) ){
                    mostVotes = subObjective.voters.length;
                    prioritizedSubObjective = subObjective;
                }
            }

            //See if it can be executed
            if(actualSavings > prioritizedSubObjective.totalToPay){
                if(isFirstInPriority){
                    //TODO: Execute sub objective code for its address
                    actualSavings = actualSavings - prioritizedSubObjective.totalToPay;
                    executedSubObj = true;
                }
                else {
                    prioritizedSubObjective.nonPrelationOrders++;
                    if(prioritizedSubObjective.nonPrelationOrders >= 2){
                        //TODO: Execute sub objective code for its address
                        actualSavings = actualSavings - prioritizedSubObjective.totalToPay;
                        executedSubObj = true;
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