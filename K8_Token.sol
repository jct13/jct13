// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol';
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Capped.sol';
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol#L15-L35';

//token for real estate
contract K8Token is ERC20{
    address public owner;
    uint256 private  _cap;
    string Street = "Kirchstrasse"; 
    string Number = "8";
    string Zipcode = "56179";
    string City = "Vallendar";
    string Countrycode = "DE";
    string NumberOfFlats = "3 Apartments";
    string Total_sqm = "350 sqm";

    // initializes contract with 100 Tokens
    constructor() ERC20('Kirchstrasse 8', 'K8') { 
        _cap = 100;
        
        // mint #Tokens = cap
        _mint(msg.sender, _cap);
        owner = msg.sender;       
    }
    
    //retruns max amount of tokkens, does 
    function cap() public view virtual returns (uint256) { 
        return _cap;
    }
    // returns information about property 
    function info() public view virtual returns(string memory,string memory,string memory,string memory,string memory,string memory, string memory){
        return (Street, Number, Zipcode, City, Countrycode, NumberOfFlats, Total_sqm);
    }

    //logs amounts Dividend received
    event receive_Dividends(uint256 dividends);
    
    // receive function for receiving dividends
    receive() external payable{
        emit receive_Dividends(msg.value);
    } 
  
}


// contract to pay Dividends
contract payDividends{
    constructor()payable{} 
    
    // function to pay Dividends, paid in Finney 
    uint256 public  div_paid;
    function sendDividends(address payable _to, uint256 total_Div) external payable{
        K8Token numberOfTokens = K8Token(_to);
        K8Token cap = K8Token(_to);
        uint256 allTokens = cap.cap();   
        uint256 ownedTokens = numberOfTokens.balanceOf(_to);
        
        // send amount of Tokens in relation to ownership percentage
        if(ownedTokens< allTokens){
            uint256 div = ownedTokens*total_Div*1e13;
            _to.transfer(div);
            div_paid += div; 
        }else{
            uint256 div = total_Div*1e15;
            _to.transfer(div);
            div_paid += div;
            
        }  
        
    }    

}


