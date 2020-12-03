//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1; 
pragma experimental ABIEncoderV2;

import "./ContratoAhorristaConfig.sol";
  

contract ContratoGestorVoting is ContratoAhorristaConfig {

    modifier onGestorVotingPeriod() {
        require(isGestorVotingPeriod == true, "You can only vote for a gestor in gestor voting period.");
        _;
    }
    modifier onGestorPostulationPeriod() {
        require(isGestorPostulationPeriod == true, "You can only postulate in postulation period.");
        _;
    }
    modifier moreThanSixActiveSavers() {
        require(config.activeSavers >= 6, "You can only start gestor voting if there are 6 or more savers active.");
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
            if (mappings.postulatedSaversStructs[postulatedSaversArray[i]].runsForGestor && 
                mappings.postulatedSaversStructs[postulatedSaversArray[i]].votesForGestor > mostVotesForGestor){
                mostVotesForGestor = mappings.postulatedSaversStructs[postulatedSaversArray[i]].votesForGestor;
                secondMostVotedGestor = mostVotedGestor;
                mostVotedGestor =  mappings.postulatedSaversStructs[postulatedSaversArray[i]];
            }
            if (mappings.postulatedSaversStructs[postulatedSaversArray[i]].runsForAudit && 
                mappings.postulatedSaversStructs[postulatedSaversArray[i]].votesForAudit > mostVotesForAudit){
                mostVotesForAudit = mappings.postulatedSaversStructs[postulatedSaversArray[i]].votesForAudit;
                secondMostVotedAudit = mostVotedAudit;
                mostVotedAudit =  mappings.postulatedSaversStructs[postulatedSaversArray[i]];
            }
        }

        //Si el más votado es el mismo, se queda con el cargo para el que más apoyo tubo TODO: Controlar que los numeros de ahorristas gestores y auditores esten en los numeros correctos.
        if(mostVotedGestor.postulatorAddress == mostVotedAudit.postulatorAddress){
            if(mostVotedGestor.votesForAudit > mostVotedGestor.votesForGestor){
                mappings.ahorristaStructs[mostVotedAudit.postulatorAddress].isAuditor = true;
                mappings.ahorristaStructs[secondMostVotedGestor.postulatorAddress].isGestor = true;
            }else{
                mappings.ahorristaStructs[mostVotedGestor.postulatorAddress].isGestor = true;
                mappings.ahorristaStructs[secondMostVotedAudit.postulatorAddress].isAuditor = true;
            }
        } else {
                mappings.ahorristaStructs[mostVotedAudit.postulatorAddress].isAuditor = true;
                mappings.ahorristaStructs[mostVotedGestor.postulatorAddress].isGestor = true;
        }
        //Borro los datos del período de la votación.

        for (uint i=0; i< postulatedSaversArray.length; i++) {
            mappings.postulatedSaversStructs[postulatedSaversArray[i]].runsForGestor = false;
            mappings.postulatedSaversStructs[postulatedSaversArray[i]].runsForAudit = false;
            mappings.postulatedSaversStructs[postulatedSaversArray[i]].votesForGestor = 0;
            mappings.postulatedSaversStructs[postulatedSaversArray[i]].votesForAudit = 0;
        }

        for (uint i=0; i< gestorVotersPerPeriod.length; i++) {
            mappings.votedLogs[gestorVotersPerPeriod[i]].votedGestor = false;
            mappings.votedLogs[gestorVotersPerPeriod[i]].votedAudit = false;
        }

    }

    function postulateFor(bool postulateGestor, bool postulateAuditor) public onlyAhorristaSimple isSaverActive onGestorPostulationPeriod  {
        postulatedSaversArray.push(msg.sender);
        mappings.postulatedSaversStructs[msg.sender] = Postulation(
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
        if(mappings.postulatedSaversStructs[gestorToVote].runsForGestor){
            if(!mappings.votedLogs[msg.sender].exists){
                gestorVotersPerPeriod.push(msg.sender);
                mappings.votedLogs[msg.sender] = VoteLog(
                    {
                        votedGestor: true,
                        votedAudit: false,
                        exists: true
                    }
                );
                mappings.postulatedSaversStructs[gestorToVote].votesForGestor++;
            }
            else {
                if(!mappings.votedLogs[msg.sender].votedGestor){
                    mappings.votedLogs[msg.sender].votedGestor = true;
                    mappings.postulatedSaversStructs[gestorToVote].votesForGestor++;
                }
            }
        }
    }
    function voteAuditor(address auditToVote) public onlyAhorristaSimple isSaverActive onGestorVotingPeriod  {
        if(mappings.postulatedSaversStructs[auditToVote].runsForAudit){
            
            if(!mappings.votedLogs[msg.sender].exists){
                gestorVotersPerPeriod.push(msg.sender);
                mappings.votedLogs[msg.sender] = VoteLog(
                    {
                        votedGestor: false,
                        votedAudit: true,
                        exists: true
                    }
                );
                mappings.postulatedSaversStructs[auditToVote].votesForAudit++;
            }
            else {
                if(!mappings.votedLogs[msg.sender].votedAudit){
                    mappings.votedLogs[msg.sender].votedAudit = true;
                    mappings.postulatedSaversStructs[auditToVote].votesForAudit++;
                }
            }
        }
    }
}