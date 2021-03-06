pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/token/StandardToken.sol";
import "zeppelin-solidity/contracts/token/MintableToken.sol";


/**
 * @title SimpleToken
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `StandardToken` functions.
 */
contract EndorToken is MintableToken {
    string public constant name = "EndorToken";
    string public constant symbol = "EDR";
    uint8 public constant decimals = 18;
    uint256 public constant FINAL_SUPPLY = 150000000 * (10 ** uint256(decimals));

    function getAvailableTokens() public view returns(uint256) {
        return FINAL_SUPPLY - totalSupply;
    }
}
