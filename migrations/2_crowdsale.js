const EndorCrowdsale = artifacts.require("EndorCrowdsale");

module.exports = function(deployer, network, accounts) {
    const startTime = new Date().getTime() / 1000;
    const endTime = startTime + 20;
    if (network === "development") {
        deployer
            .deploy(EndorCrowdsale, startTime, endTime, 2, 10, 1, accounts[0],
                5 * Math.pow(10, 18), 5 * Math.pow(10, 18));
    }
};
