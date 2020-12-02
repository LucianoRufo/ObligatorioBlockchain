//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;

import "./ContratoAhorristaConfig.sol";


contract ContratoGestorVoting is ContratoAhorristaConfig {

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


    bool public isGestorVotingPeriod;
    bool public isGestorPostulationPeriod;

    address[] public postulatedSaversArray;
    address[] public gestorVotersPerPeriod;

    mapping(address => Postulation) public postulatedSaversStructs; 
    mapping(address => VoteLog) public votedLogs; 

    modifier onGestorVotingPeriod() {
        require(isGestorVotingPeriod == true, "You can only vote for a gestor in gestor voting period.");
        _;
    }
    modifier onGestorPostulationPeriod() {
        require(isGestorPostulationPeriod == true, "You can only postulate in postulation period.");
        _;
    }
    modifier moreThanSixActiveSavers() {
        require(activeSavers >= 6, "You can only start gestor voting if there are 6 or more savers active.");
        _;
    }
    constructor( )
      ContratoAhorristaConfig() public { } 

    function startGestorPostulation() public onlyAdmin moreThanSixActiveSavers  {
        isGestorPostulationPeriod = true;
    }

    function startGestorVoting() public onlyAdmin {
        isGestorPostulationPeriod = false;
        isGestorVotingPeriod = true;
    }

    function finishGestorVoting() public onlyAdmin {
        isGestorVotingPeriod = false;
        //Getting most voted contenders.
        uint mostVotesForAudit = 0;
        uint mostVotesForGestor = 0;
        Postulation memory mostVotedGestor;
        Postulation memory secondMostVotedGestor;
        Postulation memory mostVotedAudit;
        Postulation memory secondMostVotedAudit;

        for (uint i=0; i< postulatedSaversArray.length; i++) {
            if (postulatedSaversStructs[postulatedSaversArray[i]].runsForGestor && 
                postulatedSaversStructs[postulatedSaversArray[i]].votesForGestor > mostVotesForGestor){
                mostVotesForGestor = postulatedSaversStructs[postulatedSaversArray[i]].votesForGestor;
                secondMostVotedGestor = mostVotedGestor;
                mostVotedGestor =  postulatedSaversStructs[postulatedSaversArray[i]];
            }
            if (postulatedSaversStructs[postulatedSaversArray[i]].runsForAudit && 
                postulatedSaversStructs[postulatedSaversArray[i]].votesForAudit > mostVotesForAudit){
                mostVotesForAudit = postulatedSaversStructs[postulatedSaversArray[i]].votesForAudit;
                secondMostVotedAudit = mostVotedAudit;
                mostVotedAudit =  postulatedSaversStructs[postulatedSaversArray[i]];
            }
        }

        //Si el más votado es el mismo, se queda con el cargo para el que más apoyo tubo TODO: Controlar que los numeros de ahorristas gestores y auditores esten en los numeros correctos.
        if(mostVotedGestor.postulatorAddress == mostVotedAudit.postulatorAddress){
            if(mostVotedGestor.votesForAudit > mostVotedGestor.votesForGestor){
                ahorristaStructs[mostVotedAudit.postulatorAddress].isAuditor = true;
                ahorristaStructs[secondMostVotedGestor.postulatorAddress].isGestor = true;
            }else{
                ahorristaStructs[mostVotedGestor.postulatorAddress].isGestor = true;
                ahorristaStructs[secondMostVotedAudit.postulatorAddress].isAuditor = true;
            }
        } else {
                ahorristaStructs[mostVotedAudit.postulatorAddress].isAuditor = true;
                ahorristaStructs[mostVotedGestor.postulatorAddress].isGestor = true;
        }
        //Borro los datos del período de la votación.

        for (uint i=0; i< postulatedSaversArray.length; i++) {
            postulatedSaversStructs[postulatedSaversArray[i]].runsForGestor = false;
            postulatedSaversStructs[postulatedSaversArray[i]].runsForAudit = false;
            postulatedSaversStructs[postulatedSaversArray[i]].votesForGestor = 0;
            postulatedSaversStructs[postulatedSaversArray[i]].votesForAudit = 0;
        }

        for (uint i=0; i< gestorVotersPerPeriod.length; i++) {
            votedLogs[gestorVotersPerPeriod[i]].votedGestor = false;
            votedLogs[gestorVotersPerPeriod[i]].votedAudit = false;
        }

    }

    function postulateFor(bool postulateGestor, bool postulateAuditor) public onlyAhorristaSimple isSaverActive onGestorPostulationPeriod  {
        postulatedSaversArray.push(msg.sender);
        postulatedSaversStructs[msg.sender] = Postulation(
            {
                postulatorAddress: msg.sender,
                runsForGestor: postulateGestor,
                runsForAudit: postulateAuditor,
                votesForGestor: 0,
                votesForAudit: 0
            }
        );
    }
    function voteGestor(address gestorToVote) public onlyAhorristaSimple isSaverActive onGestorVotingPeriod  {
        if(postulatedSaversStructs[gestorToVote].runsForGestor){
            if(!votedLogs[msg.sender].exists){
                gestorVotersPerPeriod.push(msg.sender);
                votedLogs[msg.sender] = VoteLog(
                    {
                        votedGestor: true,
                        votedAudit: false,
                        exists: true
                    }
                );
                postulatedSaversStructs[gestorToVote].votesForGestor++;
            }
            else {
                if(!votedLogs[msg.sender].votedGestor){
                    votedLogs[msg.sender].votedGestor = true;
                    postulatedSaversStructs[gestorToVote].votesForGestor++;
                }
            }
        }
    }
    function voteAuditor(address auditToVote) public onlyAhorristaSimple isSaverActive onGestorVotingPeriod  {
        if(postulatedSaversStructs[auditToVote].runsForAudit){
            
            if(!votedLogs[msg.sender].exists){
                gestorVotersPerPeriod.push(msg.sender);
                votedLogs[msg.sender] = VoteLog(
                    {
                        votedGestor: false,
                        votedAudit: true,
                        exists: true
                    }
                );
                postulatedSaversStructs[auditToVote].votesForAudit++;
            }
            else {
                if(!votedLogs[msg.sender].votedAudit){
                    votedLogs[msg.sender].votedAudit = true;
                    postulatedSaversStructs[auditToVote].votesForAudit++;
                }
            }
        }
    }
}