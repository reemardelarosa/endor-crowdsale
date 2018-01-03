pragma solidity ^0.4.18;

import './EndorToken.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */
contract Crowdsale {
    using SafeMath for int256;
    using SafeMath for uint256;

    // The token being sold
    EndorToken public token;

    // start and end timestamps where investments are allowed (both inclusive)
    uint256 public startTime;
    uint256 public endTime;

    // address where funds are collected
    address public wallet;

    // how many token units a buyer gets per wei
    uint256 public rate;
    uint256 public initialRate;
    uint256 public rateDecay;

    // amount of raised money in wei
    uint256 public weiRaised;

    /**
     * event for token purchase logging
     * @param purchaser who paid for the tokens
     * @param beneficiary who got the tokens
     * @param value weis paid for purchase
     * @param amount amount of tokens purchased
     */
    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);


    function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _finalRate,
        uint256 _initialRate, uint256 _rateDecay, address _wallet) public {
        require(_startTime >= now);
        require(_endTime >= _startTime);
        require(_initialRate > 0);
        require(_finalRate > 0);
        bool noDecay = _initialRate == _finalRate;
        bool positiveDecay = _rateDecay > 0;
        bool nonInfiniteDecay = _initialRate > _finalRate;
        require(noDecay || (positiveDecay && nonInfiniteDecay));
        require(_wallet != address(0));

        token = createTokenContract();
        startTime = _startTime;
        endTime = _endTime;
        rate = _finalRate;
        initialRate = _initialRate;
        rateDecay = _rateDecay;
        wallet = _wallet;
    }

    function getRate() public view returns (uint256) {
        uint256 daysSinceStart = now.sub(startTime).div(1 days);
        uint256 currentRate = initialRate.sub(rateDecay.mul(daysSinceStart));
        if (currentRate > rate) {
            return currentRate;
        }
        return rate;
    }

    // creates the token to be sold.
    // override this method to have crowdsale of a specific mintable token.
    function createTokenContract() internal returns (EndorToken) {
        return new EndorToken();
    }


    // fallback function can be used to buy tokens
    function () external payable {
        buyTokens(msg.sender);
    }

    // low level token purchase function
    function buyTokens(address beneficiary) public payable {
        require(beneficiary != address(0));
        require(validPurchase());

        uint256 weiAmount = msg.value;

        // calculate token amount to be created
        uint256 tokens = weiAmount.mul(getRate());

        // update state
        weiRaised = weiRaised.add(weiAmount);

        token.mint(beneficiary, tokens);
        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

        forwardFunds();
    }

    // send ether to the fund collection wallet
    // override to create custom fund forwarding mechanisms
    function forwardFunds() internal {
        wallet.transfer(msg.value);
    }

    // @return true if the transaction can buy tokens
    function validPurchase() internal view returns (bool) {
        bool withinPeriod = now >= startTime && now <= endTime;
        bool nonZeroPurchase = msg.value != 0;
        return withinPeriod && nonZeroPurchase;
    }

    // @return true if crowdsale event has ended
    function hasEnded() public view returns (bool) {
        return now > endTime;
    }


}
