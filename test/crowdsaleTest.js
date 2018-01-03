const EndorCrowdsale = artifacts.require("EndorCrowdsale");
const EndorToken = artifacts.require("EndorToken");
const expect = require('chai').expect;

contract('EndorCrowdsale', function(accounts) {
    it("Should return initial rate on the first day", function() {
        return EndorCrowdsale.deployed()
            .then(instance =>
                instance.getRate.call()
                    .then(currentRate => instance.initialRate()
                        .then(initialRate => expect(currentRate.toNumber).to.eql(initialRate.toNumber))
                    )
            );
    });

    it("Should forward all unsold tokens to owner on finish", function() {
        return EndorCrowdsale.deployed()
            .then(crowdsale =>
                crowdsale.token.call().then(tokenAddress => {
                    const token = EndorToken.at(tokenAddress);
                    return crowdsale.cap.call()
                        .then(cap =>
                            crowdsale.buyTokens.sendTransaction(accounts[2], {value: cap.toNumber()})
                                .then(() =>
                                    crowdsale.getRate.call()
                                        .then(currentRate =>
                                            token.balanceOf.call(accounts[2])
                                                .then(balance => expect(balance.toNumber()).to.equal(cap * currentRate))
                                        )
                                )
                                .then(() => crowdsale.finalize.sendTransaction())
                                .then(() => token.balanceOf.call(accounts[0]))
                                .then(ownerBalance => token.balanceOf.call(accounts[2])
                                    .then(buyerBalance =>
                                        token.FINAL_SUPPLY.call()
                                            .then(
                                                finalSupply =>
                                                    assert.isOk(ownerBalance.plus(buyerBalance).equals(finalSupply))
                                            )
                                    )
                                )
                        )
                })
            );
    });
});