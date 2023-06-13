//SPDX-License-Identifier:MIT

pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";
contract Funds{

    using SafeMathChainlink for uint256; //avoiding arithmetic errors

    mapping(address => uint256) public addressOfAccount;
    address public owner;

    constructor() public{
         owner = msg.sender;
    }

    function fund() public payable {


        uint256 minUSD = 0.5 * 10;

        require(getConvertionRate(msg.value) >= minUSD,"You need to spend more ETH!!");

        addressOfAccount[msg.sender] += msg.value;
    }
    function getVersion() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        
        return priceFeed.version();

        //we calleed the currect version of the aggregate interface
    }
    function getPrice() public view returns(uint256){

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        ( 
        //uint roundId,
         //int answer,
         //uint startAt,
         //uint timeStamp,
         //uint80 getRoundedAnswer
         ,int256 answer,,,)
         = priceFeed.latestRoundData();
                  
         //1881.44993556
         //1740.420000000000000000

         return uint(answer * 10000000000);
    }

    function getConvertionRate(uint ethIhave) public view returns(uint)
    {
        uint currentEthPrice = getPrice();
        uint enteredEthAmount = currentEthPrice * ethIhave;
        return enteredEthAmount/1000000000000000000000000000000000000;

        //26246828240780000000000000000000000000000 before division
        //26246 after division
        // 0.002553049720097623304487605132647558

    }
    function withdraw() public payable {
        require(msg.sender == owner);
        msg.sender.transfer(address(this).balance);
    }
    //modifiers are used to change the behaviour of a function in a declarative way.


}