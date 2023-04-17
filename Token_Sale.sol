// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

interface IERC20 
{
    function transfer(address to, uint256 amount) external;
    function decimals() external view returns(uint);
}

contract TokenSale {
    uint256 tokenPrice = 1 ether; 

    IERC20 token;

    constructor (address _token) {
        token = IERC20(_token);
    }

    function purchase(uint _numTokens) public payable {
        require (msg.value >= tokenPrice * _numTokens, "Not enough money");
        uint256 remainder = msg.value - tokenPrice * _numTokens; 
        token.transfer(msg.sender, _numTokens * 10 ** token.decimals());
        payable(msg.sender).transfer(remainder);
    }


}