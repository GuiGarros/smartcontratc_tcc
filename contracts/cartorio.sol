// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract cartorio {
    uint public valor;
    address payable public vendedor;
    address payable public comprador;



    modifier condition(bool condition_)
    {
        require(condition_);
        _;
    }


    ///Somente o comprador pode chamar essa função
    error SoComprador();
    ///Somente o vendedor pode chamar essa função
    error SoVendedor();
    ///Estado invalido para chamada da função
    error EstadoInvalido();
    /// O valor esta diferente do acordado
    error ValorErrado();

    modifier soComprador()
    {
        if(msg.sender != comprador)
            revert SoComprador();
        _;
    }

    modifier soVendedor()
    {
        if(msg.sender != vendedor)
            revert SoVendedor();
        _;
    }

    event cancelado();
    event compraConcluida();
    
    constructor() payable {
        vendedor = payable(msg.sender);
        valor = msg.value;
    }

    function cancela()
    external
    soVendedor
    {
        emit cancelado();
        vendedor.transfer(address(this).balance);

    }

    function concluiCompra()
    external
    soComprador
    condition(msg.value == valor)
    payable
    {
        emit compraConcluida();
        comprador = payable(msg.sender);

    }

    
}