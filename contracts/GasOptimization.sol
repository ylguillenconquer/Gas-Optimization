// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract GasOptimization {

    address owner;
    /* TECNICA 1 */
    /* Priorizar el uso de mappings al de arrays => Operaciones menos costosas */

        //Esto mejor evitarlo: 
        string [] alumnos;
        //Esto si:
        mapping (uint=>string) alumnosGasOK; 

    /* TECNICA 2*/
    /* Intentar ordenar las variables */
    //Esto NO
    uint128 a; //slot 0
    uint256 b; //slot 1
    uint128 c; //slot 2

    //Esto SI:
    uint128 a_gasOK; //slot 0
    uint128 c_gasOK; //slot 0
    uint256 b_gasOK; //slot 1

    /* TECNICA 3 */
    /* Habilitar el 'optimizer' en el ficher de configuracion */
    /*
        module.exports = {
            solidity: "0.8.18",
            settings: {
                optimizer: {
                enabled: true,
                runs: 10000,
                }
            }
            };
     */


     /* TECNICA 4 */
     /* Asignacion de variables locales */

     //Esto NO:
     function bucle() public {  
        for(uint i=0 ;i<50 ;i++){

        }
     }

     //Esto SI:
     function bucle_gasOK () public {
        uint256 len = 50;
        for(uint i=0 ;i<len ;i++){

        }
     }

     /* TECNICA 5 */
     /* Siempre que sea posible, hacer operaciones por lotes/bloques */

    function batch(string[] memory _alumnos) public {
        //do something
    }

    /* TECNICA 6 */
    /* Hacer uso de Eventos indexados  */
    //ATENCION: la version 'indexed' de strings y bytes es mas costosa que la no 'indexed'
    event IndexedEvent (address indexed user, uint indexed id); 
    
    /* TECNICA 7 */
    /* Usar siempre que se pueda varaibles immutable y constant */

    uint256 constant k = 10;
    uint256 immutable n;
    constructor(){ 
        owner = msg.sender;
        n = 2;
    }

    /* TECNICA 8 */
    /*Cuidado con uint8, a veces es mas costoso que variables de mayor tamano */

    //uint8 x;  //mejor para storage
    uint256 x; //mejor para bucles
    
    /*TECNICA 9*/
    //Borrar lo que no se vaya a utilizar

    //delete variable;

    /*TECNICA 10*/
    //Utilizar el modificador external 

    /* TECNICA 11 */
    /*Hacer uso de unchecked => cuando estemos 100% seguros de que son operaciones que no van a desbordar*/
    function suma(uint tam) external pure {
        for(uint256 i =0; i< tam; i++) {
            unchecked {
                i++;
            }
        }
    }

    /* TECNICA 12 */
    /*Usar errores personalizados*/

    function f(uint256 _amount) external view {
        require (msg.sender != address(0), "ADDRESS 0x00"); //Esto NO es un error personalizado
        _amount++;
    }

    error ADDRESS_0(address caller);
    function f_gas(uint256 _amount) external view {
        if (msg.sender == address(0)) {
            revert ADDRESS_0(address(0));
        }
        _amount++;
    }

    /* TECNICA 13 */
    /* Definir en una funcion (siempre que se pueda) lo que debe comprobar un modifier*/
    // El codigo de los modifier se "copia" en todas las instancias
    modifier onlyOwner_KO() {
        require(owner == msg.sender, "You are not the owner");
        _;
    }

    modifier onlyOwner() {
        _checkOwner ();
        _;
    }
    function _checkOwner() internal view {
        require(owner == msg.sender, "You are not the owner");
    }

    /* TECNICA 14 */
    /* Priorizar el uso de calldata antes que memory para ahorrar gas */
    //MEMORY
    function suma1 (uint[] memory numbers) external pure returns (uint) {
        uint resultado = 0 ;
        for (uint i= 0; i<numbers.length; i++) {
            resultado = resultado + numbers[i];
        }

        return resultado;
    }
    //CALLDATA
    function suma2 (uint[] calldata numbers) external pure returns (uint) {
        uint resultado = 0 ;
        for (uint i= 0; i<numbers.length; i++) {
            resultado = resultado + numbers[i];
        }

        return resultado;
    }

    //TECNICA 15
    //Siempre que se pueda, agrupar los parametros de entrada de una funcion en un struct
    struct Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    //NO
    function vote (uint8[] calldata v, bytes32[] calldata r, bytes32[] calldata s) public {
        //.....
    }

    function voteOK (Signature [] calldata sig) public {
        //.....
    }

    //TECNICA 16
    //Usar Bibliotecas o Librerias siempre que sea posible

    //TECNICA 17 
    //Evitar manipular datos de almacenamiento

    uint public number = 3;

    function addNumber() external view returns (uint) {
        uint result = 0;
        for (uint i = 0; i< number; i++) {
            result = result+number;
        }

        return result;
    }

    function addNumberOK () external view returns (uint) {
        uint result = 0;
        uint _number = number;
        for (uint i = 0; i< _number; i++) {
            result = result+_number;
        }
        return result;
    }

    //TECNICA 18
    //Usar las expresiones logicas a nuestro favor (||) (&&)

    /*
     En la expresion logica ||, si la primera funcion se resuelve como verdadera, la segunda no se ejecuta, asi que ahorramos gas

     En la expresion logica &&, si la primera funcion se evalua como falsa, la siguiente funcion no se evalua, asi que tambien ahorramos gas

     ¿Como implementamos esta tecnica? => ordenando las expresiones logicas en funcion de la probabilidad para reducir asi la necesidad de evaluar la segunda funcion
     */

     //TECNICA 19
     //Priorizar el uso de arrays de tamaño fijo, porque son mas baratos en terminos de gas que los dinamicos
     //Si se sabe a ciencia cierta el tamaño de un array, dejarlo definido, no ponerlo dinamico



}