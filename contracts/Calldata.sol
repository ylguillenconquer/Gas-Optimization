// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Calldata {
    /*MEMORY: Se usa para variables que solo se necesitan de forma temporal. 
    Una vez se ejecuta por completo la funcion, se libera el espacio en memoria */

    function sumArray (uint [] memory numbers) external pure returns (uint) {
        uint result = 0;
        for(uint i=0 ;i<numbers.length;i++){
            result = result+ numbers[i];
        }

        return result;
    }

    /*STORAGE: se usa en solidity para almacenamiento permanente de datos en la blockchain. Estos datos son accesibles y modificables*/
    struct Alumno {
        uint id;
        string name;
    }
    mapping (address=> Alumno) private alumnos;

    function setName(string memory name) public  returns (uint){
        Alumno storage alumno = alumnos[msg.sender];
        alumno.name = name; 
        alumno.id = 4;

        Alumno memory alumno2 = alumnos[msg.sender];
        alumno2.id = 1;

        return alumnos[msg.sender].id;
    }

    function sumaUno (uint[] calldata numbers) public pure returns (uint[] memory) {
        return _internalSuma(numbers);
    }

    function _internalSuma (uint[] calldata nums) internal pure returns (uint[]memory) {
        uint[] memory numbers2 = new uint[] (nums.length);
        for(uint i = 0; i< nums.length; i++) {
            numbers2[i] = nums[i]+1;
        }
        return numbers2;
    }
}