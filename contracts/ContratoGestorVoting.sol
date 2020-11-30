//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;

import "./ContratoAhorristaConfig.sol";


contract ContratoGestorVoting is ContratoAhorristaConfig {


    constructor( )
      ContratoAhorristaConfig() public { } 

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