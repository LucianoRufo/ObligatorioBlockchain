//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;

import "./ContratoAhorristaConfig.sol";


contract ContratoGestorVoting is ContratoAhorristaConfig {


    address[] public gestorVotersPerPeriod;
    bool public isGestorVotingPeriod;
    bool public isGestorPostulationPeriod;

    address[] public postulatedAhorrists;
    mapping(address => Ahorrista) public postulatedAhorristsStructs; 


    constructor( )
      ContratoAhorristaConfig() public { } 

    function startGestorPostulation() public onlyAdmin {
        isGestorPostulationPeriod = true;
    }
    function startGestorVoting() public onlyAdmin {
        isGestorPostulationPeriod = false;
        isGestorVotingPeriod = true;
    }
    function finishGestorVoting() public onlyAdmin {
        isGestorVotingPeriod = false;
        //TODO: clean data
    }

    function postulateFor(bool postulateGestor, bool postulateAuditor) public onlyAhorristaSimple isSaverActive  {
        //TODO
    }
  

}