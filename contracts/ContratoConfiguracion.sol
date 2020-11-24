//SPDX-License-Identifier:MIT;
pragma solidity ^0.6.1;

contract ContratoConfiguracion {
   string public publicVariable;
    constructor() public {
        publicVariable = 'Constructor in father';
    }
    function PublicFunction() public virtual { publicVariable = 'PublicVariable in Config'; }
}