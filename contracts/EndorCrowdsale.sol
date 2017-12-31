pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol";
import "./EndorToken.sol";

contract EndorCrowdsale is RefundableCrowdsale {
    function EndorCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _goal)
    RefundableCrowdsale(_goal)
    Crowdsale(_startTime, _endTime, _rate, _wallet) public payable {}

    function createTokenContract() internal returns (MintableToken) {
        EndorToken token = new EndorToken();
        token.transferOwnership(msg.sender);
        return token;
    }
}