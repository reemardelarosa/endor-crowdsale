pragma solidity ^0.4.18;

import "./RefundableCrowdsale.sol";
import "./CappedCrowdsale.sol";
import "./EndorToken.sol";

contract EndorCrowdsale is RefundableCrowdsale  {
    function EndorCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _finalRate,
        uint256 _initialRate, uint256 _rateDecay, address _wallet, uint256 _goal, uint256 _cap)
    RefundableCrowdsale(_goal, _cap)
    Crowdsale(_startTime, _endTime, _finalRate, _initialRate, _rateDecay, _wallet) public payable {}

    function finalization() internal {
        uint256 availableTokens = token.getAvailableTokens();
        token.mint(wallet, availableTokens);
        TokenPurchase(wallet, wallet, 0, availableTokens);
        token.finishMinting();
        super.finalization();
    }
}
